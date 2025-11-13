import 'package:crypto_app/src/screens/details/view.dart';
import 'package:crypto_app/src/screens/home/provider/coinlist_provider.dart';
import 'package:crypto_app/src/screens/shared/coinlist_widget.dart';
import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'dart:async';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // -----------------------------------------------------------------
  // Pagination
  // -----------------------------------------------------------------
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(coinListProvider.notifier).refreshCoinsAll();
    }
  }

  // -----------------------------------------------------------------
  // Search debounce
  // -----------------------------------------------------------------
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {}); // trigger rebuild with new filter
    });
  }

  // -----------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final coinsAsync = ref.watch(coinListProvider);
    // final query = _searchController.text.trim().toLowerCase();
    final coinNotifier = ref.read(coinListProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Search ----------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.05,
                vertical: 8,
              ),
              child: SearchBar(
                controller: _searchController,
                padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: WidgetStateColor.resolveWith(
                  (_) => Colors.white.withValues(alpha: 0.1),
                ),
                hintText: 'Search coins…',
                leading: const Icon(LucideIcons.search, size: 26),
                trailing: _searchController.text.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      ]
                    : null,
                onChanged: (query) => coinNotifier.filterCoins(query),
              ),
            ),

            // ---------- List ----------
            Expanded(
              child: coinsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00D09C)),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (coins) {
                  // ---- FILTER ----
                  // final filtered = query.isEmpty
                  //     ? coins
                  //     : coins.where((c) {
                  //         final name = (c.name ?? '').toLowerCase();
                  //         final symbol = (c.symbol ?? '').toLowerCase();
                  //         return name.contains(query) || symbol.contains(query);
                  //       }).toList();

                  // // ---- EMPTY STATE ----
                  // if (filtered.isEmpty && query.isNotEmpty) {
                  //   return Center(
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         const Icon(
                  //           LucideIcons.searchX,
                  //           size: 48,
                  //           color: Colors.grey,
                  //         ),
                  //         const Gap(12),
                  //         Text('No coins found for "$query"'),
                  //       ],
                  //     ),
                  //   );
                  // }

                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      _searchController.clear(); // optional: clear on pull
                      ref.read(coinListProvider.notifier).refreshCoinsAll();
                    },
                    // child:
                    //  ListView.builder(
                    //   itemCount: coins.length,
                    //   itemBuilder: (_, i) => ListTile(
                    //     title: Text(coins[i].name!),
                    //     subtitle: Text(coins[i].symbol!.toUpperCase()),
                    //   ),
                    // ),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.width * 0.05,
                      ),
                      itemCount: coins.length, // +1 for loader
                      itemBuilder: (context, i) {
                        // ---- Loader at bottom ----
                        // if (i == filtered.length) {
                        //   final hasMore = ref
                        //       .read(coinListProvider.notifier)
                        //       .hasMore;
                        //   return Padding(
                        //     padding: const EdgeInsets.all(16),
                        //     child: Center(
                        //       child: hasMore
                        //           ? const CircularProgressIndicator()
                        //           : const Text('No more data'),
                        //     ),
                        //   );
                        // }

                        final coin = coins[i];
                        final price = coin.currentPrice;
                        final change24h = coin.priceChangePercentage24h ?? 0.0;
                        final isPositive = change24h >= 0;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CryptoDetailScreen(
                                  coinId: coin.id ?? '',
                                  coinName: coin.name ?? '',
                                  coinSymbol: coin.symbol ?? '',
                                  isPositive: isPositive,
                                  change24h: change24h,
                                  coin: coin,
                                ),
                              ),
                            ),
                            child: CoinListWidget(
                              coin: coin,
                              price: price,
                              isPositive: isPositive,
                              change24h: change24h,
                              // optional highlight (you can add param to widget)
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const Gap(80),
          ],
        ),
      ),
    );
  }
}
