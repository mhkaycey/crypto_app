import 'dart:convert';

import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  SharedPreferenceService(this._sharedPreferences);

  bool get isWalletCreated => _sharedPreferences.containsKey('walletName');

  static const _kCoinCache = 'cached_coins';
  static const _kCoinCachePage = 'cached_page';
  static const _kCoinCacheHasMore = 'cached_has_more';
  static const _kCoinCacheTimestamp = 'cached_timestamp';
  static const _kFavoriteCoins = 'favorite_coins';

  // Save coin list + pagination state
  Future<void> cacheCoinList({
    required List<CryptoCoin> coins,
    required int page,
    required bool hasMore,
  }) async {
    final jsonList = coins.map((c) => c.toJson()).toList();
    await _sharedPreferences.setString(_kCoinCache, jsonEncode(jsonList));
    await _sharedPreferences.setInt(_kCoinCachePage, page);
    await _sharedPreferences.setBool(_kCoinCacheHasMore, hasMore);
    await _sharedPreferences.setInt(
      _kCoinCacheTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> toggleFavoriteCoin(CryptoCoin coin) async {
    final favorites = await getFavoriteCoins();
    final exists = favorites.any((c) => c.id == coin.id);

    if (exists) {
      favorites.removeWhere((c) => c.id == coin.id);
    } else {
      favorites.add(coin);
    }

    final encoded = jsonEncode(favorites.map((c) => c.toJson()).toList());
    await _sharedPreferences.setString(_kFavoriteCoins, encoded);
  }

  Future<List<CryptoCoin>> getFavoriteCoins() async {
    final jsonStr = _sharedPreferences.getString(_kFavoriteCoins);
    if (jsonStr == null) return [];
    final List decoded = jsonDecode(jsonStr);
    return decoded.map((j) => CryptoCoin.fromJson(j)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavoriteCoins();
    return favorites.any((c) => c.id == id);
  }

  // Load cached coin list + state
  Future<({List<CryptoCoin> coins, int page, bool hasMore})?>
  getCachedCoinList() async {
    final jsonStr = _sharedPreferences.getString(_kCoinCache);
    if (jsonStr == null) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      final coins = jsonList.map((j) => CryptoCoin.fromJson(j)).toList();
      final page = _sharedPreferences.getInt(_kCoinCachePage) ?? 1;
      final hasMore = _sharedPreferences.getBool(_kCoinCacheHasMore) ?? true;
      return (coins: coins, page: page, hasMore: hasMore);
    } catch (e) {
      return null;
    }
  }

  // Optional: Clear cache (e.g., on logout)
  Future<void> clearCoinCache() async {
    await _sharedPreferences.remove(_kCoinCache);
    await _sharedPreferences.remove(_kCoinCachePage);
    await _sharedPreferences.remove(_kCoinCacheHasMore);
    await _sharedPreferences.remove(_kCoinCacheTimestamp);
  }

  Future<void> saveWalletName(String walletName) async {
    await _sharedPreferences.setString('walletName', walletName);
  }

  Future<void> addAmount(double amount) async {
    final currentAmount = _sharedPreferences.getDouble('amount') ?? 0.0;
    final newAmount = currentAmount + amount;
    await _sharedPreferences.setDouble('amount', newAmount);
  }

  double getAmount() {
    final value = _sharedPreferences.get('amount');

    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  String getWalletName() {
    return _sharedPreferences.getString('walletName') ?? '';
  }

  Future<double> removeAmount(double amount) async {
    final currentAmount = getAmount();
    final newAmount = currentAmount - amount;
    await _sharedPreferences.setDouble('amount', newAmount);
    return newAmount;
  }
}
