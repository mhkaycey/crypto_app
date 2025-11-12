class MarketChartData {
  final DateTime date;
  final double price;
  final double? marketCap;
  final double? totalVolume;

  MarketChartData({
    required this.date,
    required this.price,
    this.marketCap,
    this.totalVolume,
  });

  factory MarketChartData.fromJsonListItem(List<dynamic> item) {
    return MarketChartData(
      date: DateTime.fromMillisecondsSinceEpoch(item[0] as int),
      price: (item[1] as num).toDouble(),
    );
  }

  static List<MarketChartData> fromPriceList(List<List<dynamic>> prices) {
    return prices
        .map((item) => MarketChartData.fromJsonListItem(item))
        .toList();
  }

  @override
  String toString() {
    return 'MarketChartData(date: $date, price: $price)';
  }
}

class OhlcData {
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;

  OhlcData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
