// src/screens/details/crypto_detail_screen.dart
import 'package:crypto_app/src/screens/details/model/details_model.dart';
import 'package:crypto_app/src/screens/details/provider/coin_chart.dart';
import 'package:crypto_app/src/screens/details/provider/coin_details.dart';
import 'package:crypto_app/src/screens/details/provider/favorite_provider.dart';
import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:crypto_app/src/utils/extensions.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class CryptoDetailScreen extends ConsumerStatefulWidget {
  final String coinId;
  final String coinName;
  final String coinSymbol;
  final bool isPositive;
  final num change24h;
  final CryptoCoin coin;

  const CryptoDetailScreen({
    super.key,
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.isPositive,
    required this.change24h,
    required this.coin,
  });

  @override
  ConsumerState<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends ConsumerState<CryptoDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int selectedDays = 7;
  // final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _refreshController.dispose();
    super.dispose();
  }

  // void _onRefresh() async {
  //   ref.invalidate(coinDetailProvider(widget.coinId));
  //   ref.invalidate(coinChartProvider((widget.coinId, selectedDays)));
  //   await Future.delayed(const Duration(seconds: 1));
  //   _refreshController.refreshCompleted();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favorites = ref.watch(favoriteProvider);
    final favNotifier = ref.read(favoriteProvider.notifier);

    final detailAsync = ref.watch(coinDetailProvider(widget.coinId));
    // final chartAsync = ref.watch(
    //   coinChartProvider((widget.coinId, selectedDays)),
    // );

    final chartAsync = ref.watch(
      ohlcChartProvider((widget.coinId, selectedDays)),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.coinName),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.titleLarge?.color,
      ),
      // body: SmartRefresher(
      //   controller: _refreshController,
      //   onRefresh: _onRefresh,
      //   header: WaterDropHeader(
      //     waterDropColor: Colors.blueAccent,
      //     complete: const Icon(Icons.check, color: Colors.green),
      //   ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Card
              detailAsync.when(
                data: (detail) => _buildHeaderCard(
                  detail,
                  theme,
                  isDark,
                  isPositive: widget.isPositive,
                  change24h: widget.change24h.toDouble(),
                ),
                loading: () => _buildShimmerHeader(),
                error: (_, __) => _buildErrorCard(
                  () => ref.refresh(coinDetailProvider(widget.coinId)),
                ),
              ),

              const SizedBox(height: 24),

              // Time Range Selector
              _buildTimeRangeSelector(theme),

              const SizedBox(height: 16),

              // Chart
              SizedBox(
                height: 300,
                child: chartAsync.when(
                  data: (spots) {
                    if (spots.isEmpty) {
                      return _buildEmptyChart(theme);
                    }

                    return CandlestickChart(
                      CandlestickChartData(
                        candlestickSpots: spots,
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                            width: 1,
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          horizontalInterval: null, // Auto-calculate
                          verticalInterval: null, // Auto-calculate
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: spots.length > 20
                                  ? (spots.length / 5).ceilToDouble()
                                  : null,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < spots.length) {
                                  // Format based on selectedDays
                                  // You can customize this based on your date data
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${value.toInt() + 1}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toStringAsFixed(0)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => _buildShimmerChart(),
                  error: (error, stackTrace) {
                    return _buildErrorChart(() {
                      ref.invalidate(
                        ohlcChartProvider((widget.coinId, selectedDays)),
                      );
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Stats Grid
              detailAsync.when(
                data: (detail) => Column(
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: ShadButton.destructive(
                            width: double.infinity,
                            height: context.width * 0.15,
                            child: Text(
                              "Sell",
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: ShadButton(
                            width: double.infinity,
                            height: context.width * 0.15,
                            child: Text(
                              "Buy",
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildStatsGrid(detail, theme),
                  ],
                ),
                loading: () => _buildShimmerStats(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    DetailModel detail,
    ThemeData theme,
    bool isDark, {
    bool isPositive = true,
    double change24h = 0,
  }) {
    // final price = detail.marketData.currentPrice.usd;
    // final change24h = detail.priceChangePercentage24hInCurrency.usd;
    // final isPositive = change24h >= 0;

    final favNotifier = ref.read(favoriteProvider.notifier);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'coin-${widget.coinId}',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(detail.image!.large ?? ''),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coinName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.coinSymbol.toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(LucideIcons.heart, size: 24).onTap(() {
                  favNotifier.toggleFavorite(widget.coin);
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${NumberFormat('#,##0.00').format(widget.coin.currentPrice)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositive ? '+' : ''}${change24h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPositive ? '↑ Bullish' : '↓ Bearish',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(ThemeData theme) {
    final ranges = [
      {'days': 1, 'label': '24H'},
      {'days': 7, 'label': '7D'},
      {'days': 30, 'label': '30D'},
      {'days': 90, 'label': '90D'},
      {'days': 365, 'label': '1Y'},
      {'days': 9999, 'label': 'ALL'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ranges.map((range) {
          final days = range['days'] as int;
          final label = range['label'] as String;
          final isSelected = selectedDays == (days == 9999 ? 9999 : days);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                setState(() => selectedDays = days == 9999 ? 9999 : days);
                ref.invalidate(
                  coinChartProvider((widget.coinId, selectedDays)),
                );
                Feedback.forTap(context);
              },
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.black
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> spots, ThemeData theme, bool isDark) {
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false, drawVerticalLine: false),
        titlesData: FlTitlesData(
          show: false,
          // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length - 1.toDouble(),
        minY: minY * 0.98,
        maxY: maxY * 1.02,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: theme.colorScheme.primary,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.3),
                  theme.colorScheme.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: theme.cardColor.withOpacity(0.95),
            tooltipBorderRadius: BorderRadius.circular(12),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(2)}',
                  TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildStatsGrid(DetailModel detail, ThemeData theme) {
    final stats = [
      {
        'label': 'Market Cap',
        'value': '\$${NumberFormat.compact().format(widget.coin.marketCap)}',
      },
      {
        'label': '24h Volume',
        'value': '\$${NumberFormat.compact().format(widget.coin.totalVolume)}',
      },
      {
        'label': 'All-Time High',
        'value': '\$${NumberFormat.compact().format(widget.coin.ath)}',
      },
      {
        'label': 'All-Time Low',
        'value': '\$${NumberFormat.compact().format(widget.coin.atl)}',
      }, // {'label': '24h Change', 'value': '${detail.priceChangePercentage24hInCurrency.usd.toStringAsFixed(2)}'},
      {
        'label': 'Circulating Supply',
        'value': NumberFormat.compact().format(widget.coin.circulatingSupply),
      },
      {
        'label': 'Total Supply',
        'value': widget.coin.totalSupply != null
            ? NumberFormat.compact().format(widget.coin.totalSupply)
            : '∞',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 4,
          color: theme.cardColor.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat['label']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value']!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Shimmer Widgets
  Widget _buildShimmerHeader() => Shimmer.fromColors(
    baseColor: Colors.grey[300]!.withValues(alpha: 0.1),
    highlightColor: Colors.grey[100]!,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(height: 120, width: double.infinity),
      ),
    ),
  );

  Widget _buildShimmerChart() => Shimmer.fromColors(
    baseColor: Colors.grey[300]!.withValues(alpha: 0.1),
    highlightColor: Colors.grey[100]!,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const SizedBox(height: 300, width: double.infinity),
    ),
  );

  Widget _buildShimmerStats() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!.withValues(alpha: 0.1),
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const SizedBox(),
      ),
    ),
  );

  Widget _buildEmptyChart(ThemeData theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.show_chart, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text('No data available', style: theme.textTheme.titleMedium),
      ],
    ),
  );

  Widget _buildErrorCard(VoidCallback onRetry) => Card(
    color: Colors.red.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 12),
          const Expanded(child: Text('Failed to load data')),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );

  Widget _buildErrorChart(VoidCallback onRetry) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('Chart failed to load'),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
