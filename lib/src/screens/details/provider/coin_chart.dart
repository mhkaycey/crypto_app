import 'package:crypto_app/src/screens/details/repository/detail_repo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final coinGeckoApi = CoinGeckoApi();
final coinChartProvider =
    FutureProvider.family<List<FlSpot>, (String coinId, int days)>((
      ref,
      params,
    ) async {
      final (coinId, days) = params;

      final result = await ref
          .read(coinDetailRepoProvider)
          .getDetailsWIthMarketData(
            coinId: coinId,
            vsCurrency: 'usd',
            days: days,
          );

      if (result.isError || result.data.isEmpty) {
        throw Exception(result.errorMessage ?? 'Failed to load data');
      }

      if (result.data.isEmpty) return [];

      final List<FlSpot> spots = result.data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.price))
          .toList();

      return spots;
    });

final ohlcChartProvider =
    FutureProvider.family<List<CandlestickSpot>, (String, int)>((
      ref,
      params,
    ) async {
      final (coinId, days) = params;

      final result = await ref
          .read(coinDetailRepoProvider)
          .getOhlcData(coinId: coinId, vsCurrency: 'usd', days: days);

      if (result.isError || result.data.isEmpty) {
        throw Exception('No OHLC data');
      }

      return result.data
          .asMap()
          .entries
          .map(
            (e) => CandlestickSpot(
              x: e.key.toDouble(),
              open: e.value.open,
              high: e.value.high,
              low: e.value.low,
              close: e.value.close,
            ),
          )
          .toList();
    });
