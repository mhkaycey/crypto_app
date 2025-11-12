class ApiEndpoints {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  static const String coinsMarkets = '/coins/markets';

  static coinDetails(String id) => '/coins/$id';
  static coinDetailsWithMarketChart(String id) => '/coins/$id/market_chart';
}
