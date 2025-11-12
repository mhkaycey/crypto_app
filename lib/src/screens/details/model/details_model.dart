import 'package:crypto_app/src/screens/details/model/market_data.dart';

class DetailModel {
  final String? id;
  final String? symbol;
  final String? name;
  final String? webSlug;
  final int? blockTimeInMinutes;
  final String? hashingAlgorithm;
  final List<String>? categories;
  final Description? description;
  final Links? links;
  final ImageData? image;
  final String? countryOrigin;
  final String? genesisDate;
  final double? sentimentVotesUpPercentage;
  final double? sentimentVotesDownPercentage;
  final int? watchlistPortfolioUsers;
  final int? marketCapRank;
  final DeveloperData? developerData;
  final String? lastUpdated;
  final List<Ticker>? tickers;
  final Sparkline7d? sparkline7d;
  final MarketData? marketData;

  DetailModel({
    this.id,
    this.symbol,
    this.name,
    this.webSlug,
    this.blockTimeInMinutes,
    this.hashingAlgorithm,
    this.categories,
    this.description,
    this.links,
    this.image,
    this.countryOrigin,
    this.genesisDate,
    this.sentimentVotesUpPercentage,
    this.sentimentVotesDownPercentage,
    this.watchlistPortfolioUsers,
    this.marketCapRank,
    this.developerData,
    this.lastUpdated,
    this.tickers,
    this.sparkline7d,
    this.marketData,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      webSlug: json['web_slug'] as String?,
      blockTimeInMinutes: json['block_time_in_minutes'] as int?,
      hashingAlgorithm: json['hashing_algorithm'] as String?,
      categories: List<String>.from(json['categories'] ?? []),
      description: Description.fromJson(
        json['description'] as Map<String, dynamic>,
      ),
      links: Links.fromJson(json['links'] as Map<String, dynamic>),
      image: ImageData.fromJson(json['image'] as Map<String, dynamic>),
      countryOrigin: json['country_origin'] as String? ?? '',
      genesisDate: json['genesis_date'] as String?,
      sentimentVotesUpPercentage:
          (json['sentiment_votes_up_percentage'] as num?)?.toDouble() ?? 0.0,
      sentimentVotesDownPercentage:
          (json['sentiment_votes_down_percentage'] as num?)?.toDouble() ?? 0.0,
      watchlistPortfolioUsers: json['watchlist_portfolio_users'] as int? ?? 0,
      marketCapRank: json['market_cap_rank'] as int? ?? 0,
      developerData: json['developer_data'] != null
          ? DeveloperData.fromJson(
              json['developer_data'] as Map<String, dynamic>,
            )
          : null,
      lastUpdated: json['last_updated'] as String,
      tickers:
          (json['tickers'] as List?)
              ?.map((e) => Ticker.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sparkline7d: json['sparkline_7d'] != null
          ? Sparkline7d.fromJson(json['sparkline_7d'])
          : null,

      marketData: json['market_data'] != null
          ? MarketData.fromJson(json['market_data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Description {
  final String? en;

  Description({this.en});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(en: json['en'] as String);
  }
}

class Links {
  final List<String>? homepage;
  final String? whitepaper;
  final List<String>? blockchainSite;
  final List<String>? officialForumUrl;
  final String? twitterScreenName;
  final String? facebookUsername;
  final String? subredditUrl;
  // final ReposUrl? reposUrl;

  Links({
    this.homepage,
    this.whitepaper,
    this.blockchainSite,
    this.officialForumUrl,
    this.twitterScreenName,
    this.facebookUsername,
    this.subredditUrl,
    // this.reposUrl,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      homepage: List<String>.from(json['homepage'] ?? []),
      whitepaper: json['whitepaper'] as String,
      blockchainSite: List<String>.from(json['blockchain_site'] ?? []),
      officialForumUrl: List<String>.from(json['official_forum_url'] ?? []),
      twitterScreenName: json['twitter_screen_name'] as String?,
      facebookUsername: json['facebook_username'] as String?,
      subredditUrl: json['subreddit_url'] as String?,
      // reposUrl: ReposUrl.fromJson(json['repos_url'] as Map<String, dynamic>),
    );
  }
}

// class ReposUrl {
//   final List<String>? github;
//   final List<String>? bitbucket;

//   ReposUrl({this.github, this.bitbucket});

//   factory ReposUrl.fromJson(Map<String, dynamic> json) {
//     return ReposUrl(
//       github: List<String>.from(json['github'] ?? []),
//       bitbucket: List<String>.from(json['bitbucket'] ?? []),
//     );
//   }
// }

class ImageData {
  final String? thumb;
  final String? small;
  final String? large;

  ImageData({this.thumb, this.small, this.large});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      thumb: json['thumb'] as String,
      small: json['small'] as String,
      large: json['large'] as String,
    );
  }
}

class DeveloperData {
  final int? forks;
  final int? stars;
  final int? subscribers;
  final int? totalIssues;
  final int? closedIssues;
  final int? pullRequestsMerged;
  final int? pullRequestContributors;
  final int? commitCount4Weeks;

  DeveloperData({
    this.forks,
    this.stars,
    this.subscribers,
    this.totalIssues,
    this.closedIssues,
    this.pullRequestsMerged,
    this.pullRequestContributors,
    this.commitCount4Weeks,
  });

  factory DeveloperData.fromJson(Map<String, dynamic> json) {
    return DeveloperData(
      forks: json['forks'] as int,
      stars: json['stars'] as int,
      subscribers: json['subscribers'] as int,
      totalIssues: json['total_issues'] as int,
      closedIssues: json['closed_issues'] as int,
      pullRequestsMerged: json['pull_requests_merged'] as int,
      pullRequestContributors: json['pull_request_contributors'] as int,
      commitCount4Weeks: json['commit_count_4_weeks'] as int,
    );
  }
}

class Ticker {
  final String? base;
  final String? target;
  final Market? market;
  final double? last;
  final double? volume;
  final ConvertedValue? convertedLast;
  final ConvertedValue? convertedVolume;
  final String? trustScore;
  final double? bidAskSpreadPercentage;
  final String? timestamp;
  final String? lastTradedAt;
  final String? tradeUrl;
  final String? coinId;

  Ticker({
    this.base,
    this.target,
    this.market,
    this.last,
    this.volume,
    this.convertedLast,
    this.convertedVolume,
    this.trustScore,
    this.bidAskSpreadPercentage,
    this.timestamp,
    this.lastTradedAt,
    this.tradeUrl,
    this.coinId,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      base: json['base'] as String,
      target: json['target'] as String,
      market: Market.fromJson(json['market'] as Map<String, dynamic>),
      last: (json['last'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      convertedLast: ConvertedValue.fromJson(
        json['converted_last'] as Map<String, dynamic>,
      ),
      convertedVolume: ConvertedValue.fromJson(
        json['converted_volume'] as Map<String, dynamic>,
      ),
      trustScore: json['trust_score'] as String,
      bidAskSpreadPercentage: (json['bid_ask_spread_percentage'] as num)
          .toDouble(),
      timestamp: json['timestamp'] as String,
      lastTradedAt: json['last_traded_at'] as String,
      tradeUrl: json['trade_url'] as String?,
      coinId: json['coin_id'] as String,
    );
  }
}

class Market {
  final String? name;
  final String? identifier;
  final bool? hasTradingIncentive;

  Market({this.name, this.identifier, this.hasTradingIncentive});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      name: json['name'] as String,
      identifier: json['identifier'] as String,
      hasTradingIncentive: json['has_trading_incentive'] as bool,
    );
  }
}

class ConvertedValue {
  final double? btc;
  final double? eth;
  final double? usd;

  ConvertedValue({this.btc, this.eth, this.usd});

  factory ConvertedValue.fromJson(Map<String, dynamic> json) {
    return ConvertedValue(
      btc: (json['btc'] as num).toDouble(),
      eth: (json['eth'] as num).toDouble(),
      usd: (json['usd'] as num).toDouble(),
    );
  }
}

class Sparkline7d {
  final List<double> price;

  Sparkline7d({required this.price});

  factory Sparkline7d.fromJson(Map<String, dynamic> json) {
    return Sparkline7d(
      price: List<double>.from(json['price'].map((x) => (x as num).toDouble())),
    );
  }
}

// class Sparkline7d {
//   final List<double>? price;

//   Sparkline7d({this.price});

//   factory Sparkline7d.fromJson(Map<String, dynamic> json) {
//     return Sparkline7d(
//       price: (json['price'] as List).map((e) => (e as num).toDouble()).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {'price': price};
// }
