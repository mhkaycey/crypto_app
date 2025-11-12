class MarketData {
  final Map<String, double>? currentPrice;
  final dynamic totalValueLocked;
  final dynamic mcapToTvlRatio;
  final dynamic fdvToTvlRatio;
  final dynamic roi;

  final Map<String, double>? ath;
  final Map<String, double>? athChangePercentage;
  final Map<String, String>? athDate;

  final Map<String, double>? atl;
  final Map<String, double>? atlChangePercentage;
  final Map<String, String>? atlDate;

  final Map<String, double>? marketCap;

  MarketData({
    this.currentPrice,
    this.totalValueLocked,
    this.mcapToTvlRatio,
    this.fdvToTvlRatio,
    this.roi,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.marketCap,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      currentPrice: _toDoubleMap(json['current_price']),
      totalValueLocked: json['total_value_locked'],
      mcapToTvlRatio: json['mcap_to_tvl_ratio'],
      fdvToTvlRatio: json['fdv_to_tvl_ratio'],
      roi: json['roi'],

      ath: _toDoubleMap(json['ath']),
      athChangePercentage: _toDoubleMap(json['ath_change_percentage']),
      athDate: _toStringMap(json['ath_date']),

      atl: _toDoubleMap(json['atl']),
      atlChangePercentage: _toDoubleMap(json['atl_change_percentage']),
      atlDate: _toStringMap(json['atl_date']),

      marketCap: _toDoubleMap(json['market_cap']),
    );
  }

  static Map<String, double> _toDoubleMap(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
      data.map((key, value) => MapEntry(key, (value as num).toDouble())),
    );
  }

  static Map<String, String> _toStringMap(dynamic data) {
    if (data == null) return {};
    return Map<String, String>.from(
      data.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    "current_price": currentPrice,
    "total_value_locked": totalValueLocked,
    "mcap_to_tvl_ratio": mcapToTvlRatio,
    "fdv_to_tvl_ratio": fdvToTvlRatio,
    "roi": roi,
    "ath": ath,
    "ath_change_percentage": athChangePercentage,
    "ath_date": athDate,
    "atl": atl,
    "atl_change_percentage": atlChangePercentage,
    "atl_date": atlDate,
    "market_cap": marketCap,
  };
}
