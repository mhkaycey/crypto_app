import 'dart:developer';

import 'package:crypto_app/src/core/result/coin_result.dart';
import 'package:crypto_app/src/core/services/api_endpoints.dart';
import 'package:crypto_app/src/core/services/api_request.dart';
import 'package:crypto_app/src/screens/details/model/details_model.dart';
import 'package:crypto_app/src/screens/details/model/market_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinDetailRepoProvider = Provider((ref) => DetailRepo());

class DetailRepo {
  Future<DetailModel> getDetails(String coinId) async {
    try {
      final response = await ApiRequest.getRequest(
        ApiEndpoints.coinDetails(coinId),
        queryParameters: {
          'localization': false,
          'tickers': true,
          'market_data': false,
          'community_data': false,
          'developer_data': true,
          'sparkline': true,
        },
      );
      return DetailModel.fromJson(response?.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load  details: $e');
    }
  }

  Future<CoinResult<List<MarketChartData>>> getDetailsWIthMarketData({
    required String coinId,
    required String vsCurrency,
    int? days,
  }) async {
    try {
      final response = await ApiRequest.getRequest(
        ApiEndpoints.coinDetailsWithMarketChart(coinId),
        queryParameters: {
          'vs_currency': vsCurrency,
          'days': days?.toString() ?? 'max',
          'interval': days == 1 ? 'hourly' : 'daily',
        },
      );

      if (response?.statusCode != 200) {
        return CoinResult(
          [],
          isError: true,
          errorCode: response?.statusCode,
          errorMessage: response?.statusMessage ?? 'HTTP Error',
        );
      }

      final data = response!.data as Map<String, dynamic>;
      final pricesRaw = data['prices'];

      if (pricesRaw is! List) {
        return CoinResult(
          [],
          isError: true,
          errorMessage: 'prices field is missing or invalid',
        );
      }

      final List<MarketChartData> chartData = [];

      for (final item in pricesRaw) {
        if (item is List && item.length >= 2) {
          final timestamp = item[0];
          final price = item[1];

          if (timestamp is int && price is num) {
            chartData.add(
              MarketChartData(
                date: DateTime.fromMillisecondsSinceEpoch(timestamp),
                price: price.toDouble(),
              ),
            );
          }
        }
      }

      if (chartData.isEmpty) {
        return CoinResult(
          [],
          isError: true,
          errorMessage: 'No valid price data found',
        );
      }

      return CoinResult(chartData);
    } catch (e, stack) {
      log('Chart Error: $e\n$stack'); // Debug log
      return CoinResult([], isError: true, errorMessage: 'Exception: $e');
    }
  }

  Future<CoinResult<List<OhlcData>>> getOhlcData({
    required String coinId,
    required String vsCurrency,
    required int days,
  }) async {
    try {
      final response = await ApiRequest.getRequest(
        '/coins/$coinId/ohlc',
        queryParameters: {'vs_currency': vsCurrency, 'days': days.toString()},
      );

      if (response?.statusCode != 200) {
        return CoinResult(
          [],
          isError: true,
          errorMessage: 'Failed to load OHLC',
        );
      }

      final rawData = response!.data as List<dynamic>;
      final List<OhlcData> ohlcList = rawData.map((item) {
        final list = item as List<dynamic>;
        return OhlcData(
          timestamp: list[0] as int,
          open: (list[1] as num).toDouble(),
          high: (list[2] as num).toDouble(),
          low: (list[3] as num).toDouble(),
          close: (list[4] as num).toDouble(),
        );
      }).toList();

      return CoinResult(ohlcList);
    } catch (e) {
      return CoinResult([], isError: true, errorMessage: e.toString());
    }
  }
}
