class CryptoCoin {
  final String? id;
  final String? symbol;
  final String? name;
  final String? image;
  final num? currentPrice;
  final num? marketCap;
  final num? marketCapRank;
  final num? fullyDilutedValuation;
  final num? totalVolume;
  final num? high24h;
  final num? low24h;
  final num? priceChange24h;
  final num? priceChangePercentage24h;
  final num? marketCapChange24h;
  final num? marketCapChangePercentage24h;
  final num? circulatingSupply;
  final num? totalSupply;
  final num? maxSupply;
  final num? ath;
  final num? athChangePercentage;
  final String? athDate;
  final num? atl;
  final num? atlChangePercentage;
  final String? atlDate;
  final dynamic roi;
  final String? lastUpdated;
  final SparklineIn7d? sparklineIn7d;
  final num? priceChangePercentage1h;

  CryptoCoin({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.roi,
    this.lastUpdated,
    this.sparklineIn7d,
    this.priceChangePercentage1h,
  });
  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "image": image,
    "current_price": currentPrice,
    "market_cap": marketCap,
    "market_cap_rank": marketCapRank,
    "fully_diluted_valuation": fullyDilutedValuation,
    "total_volume": totalVolume,
    "high_24h": high24h,
    "low_24h": low24h,
    "price_change_24h": priceChange24h,
    "price_change_percentage_24h": priceChangePercentage24h,
    "market_cap_change_24h": marketCapChange24h,
    "market_cap_change_percentage_24h": marketCapChangePercentage24h,
    "circulating_supply": circulatingSupply,
    "total_supply": totalSupply,
    "max_supply": maxSupply,
    "ath": ath,
    "ath_change_percentage": athChangePercentage,
    "ath_date": athDate,
    "atl": atl,
    "atl_change_percentage": atlChangePercentage,
    "atl_date": atlDate,
    "roi": roi,
    "last_updated": lastUpdated,
    "sparkline_in_7d": sparklineIn7d?.toJson(),
    "price_change_percentage_1h": priceChangePercentage1h,
  };

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: json['current_price'],
      marketCap: json['market_cap'],
      marketCapRank: json['market_cap_rank'],
      fullyDilutedValuation: json['fully_diluted_valuation'],
      totalVolume: json['total_volume'],
      high24h: json['high_24h'],
      low24h: json['low_24h'],
      priceChange24h: json['price_change_24h'],
      priceChangePercentage24h: json['price_change_percentage_24h'],
      marketCapChange24h: json['market_cap_change_24h'],
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h'],
      circulatingSupply: json['circulating_supply'],
      totalSupply: json['total_supply'],
      maxSupply: json['max_supply'],
      ath: json['ath'],
      athChangePercentage: json['ath_change_percentage'],
      athDate: json['ath_date'],
      atl: json['atl'],
      atlChangePercentage: json['atl_change_percentage'],
      atlDate: json['atl_date'],
      roi: json['roi'],
      lastUpdated: json['last_updated'],
      sparklineIn7d: json['sparkline_in_7d'] != null
          ? SparklineIn7d.fromJson(json['sparkline_in_7d'])
          : null,

      priceChangePercentage1h: json['price_change_percentage_1h_in_currency'],
    );
  }

  static List<CryptoCoin> fromJsonList(List<dynamic> list) {
    return list.map((e) => CryptoCoin.fromJson(e)).toList();
  }
}

class SparklineIn7d {
  final List<double> price;

  SparklineIn7d({required this.price});

  factory SparklineIn7d.fromJson(Map<String, dynamic> json) {
    return SparklineIn7d(
      price: List<double>.from(json['price'].map((x) => (x as num).toDouble())),
    );
  }

  Map<String, dynamic> toJson() => {"price": price};
}
