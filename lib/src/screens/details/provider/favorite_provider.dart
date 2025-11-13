import 'package:crypto_app/src/core/provider/shared_preference.dart';
import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class FavoriteProvider extends StateNotifier<List<CryptoCoin>> {
  final Ref ref;

  FavoriteProvider(this.ref) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final service = ref.read(sharedPreferenceServiceProvider);
    final favorites = await service.getFavoriteCoins();
    state = favorites;
  }

  Future<void> toggleFavorite(CryptoCoin coin) async {
    final service = ref.read(sharedPreferenceServiceProvider);
    await service.toggleFavoriteCoin(coin);
    _loadFavorites(); // refresh list
  }

  bool isFavorite(String id) => state.any((c) => c.id == id);
}

final favoriteProvider =
    StateNotifierProvider<FavoriteProvider, List<CryptoCoin>>(
      (ref) => FavoriteProvider(ref),
    );
