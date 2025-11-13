import 'package:crypto_app/src/core/provider/connectivity_provider.dart';
import 'package:crypto_app/src/core/provider/shared_preference.dart';
import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:crypto_app/src/screens/home/repository/coin_list_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

final coinRepositoryProvider = Provider((ref) => CoinListRepository());

class CoinListNotifier extends StateNotifier<AsyncValue<List<CryptoCoin>>> {
  Ref ref;
  CoinListNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadFromCacheAndRefresh();
  }

  int page = 1;
  bool _isFetching = false;
  bool hasMore = true;

  // Keep a copy of all coins
  List<CryptoCoin> _allCoins = [];

  Future<void> _loadFromCacheAndRefresh() async {
    final service = ref.read(sharedPreferenceServiceProvider);
    final cached = await service.getCachedCoinList();

    if (cached != null) {
      page = cached.page;
      hasMore = cached.hasMore;
      _allCoins = cached.coins;
      state = AsyncValue.data(_allCoins);
    } else {
      state = const AsyncValue.loading();
    }

    final isConnected = await ref.read(isConnectedProvider.future);
    if (isConnected) {
      refreshCoinsAll();
    }
  }

  Future<void> getCoinList() async {
    if (_isFetching || !hasMore) return;
    _isFetching = true;

    try {
      final result = await ref
          .read(coinRepositoryProvider)
          .getCoinList(page: page);

      if (result.isEmpty) {
        hasMore = false;
      } else {
        page++;
        _allCoins = [..._allCoins, ...result];
        state = AsyncValue.data(_allCoins);
      }

      // Cache the data
      final service = ref.read(sharedPreferenceServiceProvider);
      await service.cacheCoinList(
        coins: _allCoins,
        page: page,
        hasMore: hasMore,
      );
    } catch (e, sk) {
      state = AsyncValue.error(e, sk);
    } finally {
      _isFetching = false;
    }
  }

  void refreshCoins() {
    page = 1;
    hasMore = true;
    _allCoins = [];
    state = const AsyncValue.loading();
    getCoinList();
  }

  void refreshCoinsAll() {
    page = 1;
    hasMore = true;
    _allCoins = [];
    state = const AsyncValue.loading();
    getCoinList();
  }

  void filterCoins(String query) {
    if (query.isEmpty) {
      state = AsyncValue.data(_allCoins);
    } else {
      final filtered = _allCoins.where((coin) {
        final nameMatch = coin.name?.toLowerCase().contains(
          query.toLowerCase(),
        );
        final symbolMatch = coin.symbol?.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatch! || symbolMatch!;
      }).toList();

      state = AsyncValue.data(filtered);
    }
  }
}

final coinListProvider =
    StateNotifierProvider<CoinListNotifier, AsyncValue<List<CryptoCoin>>>(
      (ref) => CoinListNotifier(ref),
    );
