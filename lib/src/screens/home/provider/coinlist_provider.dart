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
    getCoinList();
    getCoinListAll();
  }

  int page = 1;
  bool _isFetching = false;
  bool hasMore = true;

  Future<void> _loadFromCacheAndRefresh() async {
    final service = ref.read(sharedPreferenceServiceProvider);
    final cached = await service.getCachedCoinList();

    if (cached != null) {
      page = cached.page;
      hasMore = cached.hasMore;
      state = AsyncValue.data(cached.coins);
    } else {
      state = const AsyncValue.loading();
    }

    // Try to refresh if online
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
      }
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, ...result]);
    } catch (e, sk) {
      state = AsyncValue.error(e, sk);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> getCoinListAll() async {
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
      }

      if (result.isEmpty) {
        hasMore = false;
      } else {
        page++;
      }
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, ...result]);
    } catch (e, sk) {
      state = AsyncValue.error(e, sk);
    } finally {
      _isFetching = false;
    }
  }

  void refreshCoinsAll() {
    page = 1;
    hasMore = true;
    state = const AsyncValue.loading();
    getCoinListAll();
  }

  void refreshCoins() {
    page = 1;
    hasMore = true;
    state = const AsyncValue.loading();
    getCoinList();
  }
}

final coinListProvider =
    StateNotifierProvider<CoinListNotifier, AsyncValue<List<CryptoCoin>>>(
      (ref) => CoinListNotifier(ref),
    );
