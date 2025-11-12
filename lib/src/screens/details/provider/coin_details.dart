// // providers/coin_chart_provider.dart (updated)
// import 'dart:developer';

// import 'package:crypto_app/src/screens/home/provider/coinlist_provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final coinChartProvider =
//     FutureProvider.family<List<FlSpot>, (String coinId, int days)>((
//       ref,
//       params,
//     ) async {
//       final (coinId, days) = params;
//       final repo = ref.watch(coinRepositoryProvider);

//       // final result = await ref.r.coins.getCoinMarketChart(
//       //   id: coinId,
//       //   vsCurrency: 'usd',
//       //   days: days,
//       // );

//       final result = await repo.getCoinList(
//         page: 1,

//         // vsCurrency: 'usd',
//         // days: days,
//       );

//       if (result.isError) throw Exception(result.errorMessage);
//       log(result.data.toString());

//       // final prices = result.data.map((e) => [e., e.price]).toList();
//       // final spots = <FlSpot>[];

//       final spots = result.data
//           .asMap()
//           .entries
//           .map((entry) => FlSpot(entry.key.toDouble(), entry.value.price!))
//           .toList();

//       return spots;

//       // for (var i = 0; i < prices.length; i++) {
//       //   final timestamp = prices[i][0] as num;
//       //   final price = prices[i][1] as double;
//       //   spots.add(FlSpot(i.toDouble(), price));
//       // }

//       // return spots;
//     });

import 'dart:async';
import 'dart:developer';

import 'package:crypto_app/src/screens/details/model/details_model.dart';
import 'package:crypto_app/src/screens/details/repository/detail_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/legacy.dart';

class CoinDetailNotifier extends Notifier<AsyncValue<DetailModel>> {
  final String id;
  CoinDetailNotifier(this.id);

  @override
  AsyncValue<DetailModel> build() {
    loadCoin(id);

    return const AsyncValue.loading();
  }

  Future<void> loadCoin(String coinId) async {
    await refreshCoin(coinId);
  }

  refreshCoin(String coinId) async {
    try {
      state = const AsyncValue.loading();
      final result = await ref.read(coinDetailRepoProvider).getDetails(coinId);
      state = AsyncValue.data(result);
      log(result.toString());
    } on DioException catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      log(e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      log(e.toString(), stackTrace: stackTrace);
    }
  }
}

final coinDetailProvider =
    NotifierProvider.family<
      CoinDetailNotifier,
      AsyncValue<DetailModel>,
      String
    >(CoinDetailNotifier.new);
