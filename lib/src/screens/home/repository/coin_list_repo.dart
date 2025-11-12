import 'package:crypto_app/src/core/services/api_endpoints.dart';
import 'package:crypto_app/src/core/services/api_request.dart';
import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinRepositoryProvider = Provider<CoinListRepository>((ref) {
  return CoinListRepository();
});

class CoinListRepository {
  Future<List<CryptoCoin>> getCoinList({
    required int page,
    int perPage = 20,
    String vsCurrency = 'usd',
    bool sparkline = true,
    int? id,
  }) async {
    final response = await ApiRequest.getRequest(
      ApiEndpoints.coinsMarkets,

      queryParameters: {
        'vs_currency': vsCurrency,
        'sparkline': sparkline,
        'per_page': perPage,
        'page': page,
        'order': 'market_cap_desc',
        'id': id,
      },
    );

    if (response == null ||
        response.statusCode != 200 ||
        response.data == null) {
      return [];
    }
    return CryptoCoin.fromJsonList(response.data);
  }
}

class CoinQueryParams {
  static Map<String, dynamic> markets({
    required int page,
    int perPage = 20,
    String vsCurrency = 'usd',
    bool sparkline = true,
  }) {
    return {
      'vs_currency': vsCurrency,
      'sparkline': sparkline,
      'per_page': perPage,
      'page': page,
      'order': 'market_cap_desc',
    };
  }
}
