import 'package:crypto_app/src/core/provider/connectivity_provider.dart';
import 'package:crypto_app/src/screens/details/provider/favorite_provider.dart';
import 'package:crypto_app/src/screens/details/view.dart';
import 'package:crypto_app/src/screens/home/provider/coinlist_provider.dart';
import 'package:crypto_app/src/screens/shared/coinlist_widget.dart';
import 'package:crypto_app/src/screens/wallet_setup/provider/wallet_provider.dart';
import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

class CoinListScreen extends ConsumerStatefulWidget {
  const CoinListScreen({super.key});

  @override
  ConsumerState<CoinListScreen> createState() => CoinListScreenState();
}

class CoinListScreenState extends ConsumerState<CoinListScreen> {
  // static const String _mockAddress = "0x742d35Cc6634C0532925a3b8D4C9A";

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final favorites = ref.watch(favoriteProvider);

    final theme = ShadTheme.of(context);

    final options = [
      {'name': "Send", 'icon': LucideIcons.arrowUp},
      {'name': "Receive", 'icon': LucideIcons.arrowDown},
      {'name': "Buy", 'icon': LucideIcons.baggageClaim},
    ];

    return Scaffold(
      body:
          // favorites.when(
          //   loading: () => const Center(
          //     child: CircularProgressIndicator(color: Color(0xFF00D09C)),
          //   ),
          //   error: (err, _) {
          //     return Center(child: Text(err.toString()));
          //     // final isConnected = ref.watch(isConnectedProvider).value ?? false;
          //     // if (!isConnected && coinsAsync.value?.isNotEmpty == true) {
          //     //   return Column(
          //     //     children: [
          //     //       const Icon(Icons.cloud_off, size: 48, color: Colors.orange),
          //     //       const Text(
          //     //         'Offline - Showing cached data',
          //     //         style: TextStyle(color: Colors.orange),
          //     //       ),
          //     //       ElevatedButton(
          //     //         onPressed: () =>
          //     //             ref.read(coinListProvider.notifier).refreshCoinsAll(),
          //     //         child: const Text('Retry'),
          //     //       ),
          //     //     ],
          //     //   );
          //     // }
          //     // return null;
          //   },
          //   data: (coins) =>
          ListView(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            children: [
              const Gap(16),

              // Portfolio badge
              Container(
                // width: context.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 15),
                    const Gap(8),

                    Text(walletState.walletName, style: theme.textTheme.h4),
                  ],
                ),
              ).center(),

              const Gap(8),

              Text(
                '\$${NumberFormat('#,##0.00').format(walletState.amount)}',
                style: theme.textTheme.lead.copyWith(
                  fontSize: 30,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ).center(),

              const Gap(16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: options.map((opt) {
                  return Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          opt['icon'] as IconData,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ).onTap(() {
                        if (opt['name'] == 'Send') {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         const SendReceiveScreen(), //BuySell(),
                          //   ),
                          // );
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomWidget(isSend: true);
                            },
                          );
                        } else if (opt['name'] == 'Receive') {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomWidget(isSend: false);
                            },
                          );
                        }
                      }),
                      const Gap(4),
                      Text(opt['name'] as String),
                    ],
                  );
                }).toList(),
              ),

              const Gap(24),

              Text("My Favorite"),

              ...List.generate(favorites.length, (i) {
                final coin = favorites[i];
                final price = coin.currentPrice;
                final change24h = coin.priceChangePercentage24h ?? 0;
                final isPositive = change24h >= 0;

                return GestureDetector(
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
                  ),
                );
              }),
              const Gap(80),
            ],
          ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  final bool isSend;
  const BottomWidget({super.key, required this.isSend});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final String mockAddress = "0x742d35Cc6634C0532925a3b8D4C9A";

    return Material(
      color: Colors.transparent,
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: isSend
            ? const SendCoin()
            : ReceiveCoin(mockAddress: mockAddress, theme: theme),
      ),
    );
  }
}

class ReceiveCoin extends StatelessWidget {
  const ReceiveCoin({
    super.key,
    required this.mockAddress,
    required this.theme,
  });

  final String mockAddress;
  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(40),

          // QR Code
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: mockAddress,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
              // foregroundColor: Colors.black,
            ),
          ),

          const Gap(24),

          // Address
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    mockAddress,
                    style: theme.textTheme.muted.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: mockAddress));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address copied!'),
                          backgroundColor: Color(0xFF00D09C),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(LucideIcons.copy, size: 20),
                  tooltip: 'Copy',
                ),
              ],
            ),
          ),

          const Gap(16),

          Text(
            'Only send ETH or ERC-20 tokens to this address.',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),

          const Gap(40),
        ],
      ).paddingSymmetric(horizontal: context.width * 0.06),
    );
  }
}

class SendCoin extends ConsumerStatefulWidget {
  const SendCoin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendCoinState();
}

class _SendCoinState extends ConsumerState<SendCoin> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final theme = ShadTheme.of(context);
    return Column(
      children: [
        const Gap(24),

        // Balance Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text('Available Balance', style: theme.textTheme.small),
              const Gap(4),
              Text(
                '\$${NumberFormat('#,##0.00').format(walletState.amount)}',
                style: theme.textTheme.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00D09C),
                ),
              ),
            ],
          ),
        ),

        const Gap(32),

        // Send Form
        ShadForm(
          key: _formKey,
          child: Column(
            children: [
              // ShadInputFormField(
              //   controller: _amountController,
              //   label: const Text('Amount'),
              //   placeholder: const Text('0.00'),
              //   keyboardType:
              //       const TextInputType.numberWithOptions(decimal: true),
              //   prefix: const Padding(
              //     padding: EdgeInsets.only(left: 12),
              //     child: Icon(LucideIcons.dollarSign, size: 18),
              //   ),
              //   validator: (v) {
              //     final val = double.tryParse(v ?? '');
              //     if (val == null || val <= 0) return 'Enter valid amount';
              //     return null;
              //   },
              // ),
              ShadInput(
                placeholder: Text('Amount'),
                controller: _amountController,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(LucideIcons.dollarSign, size: 18),
                ),
              ),

              const Gap(16),

              ShadInputFormField(
                controller: _addressController,
                label: const Text('Recipient Address'),
                placeholder: const Text('0x...'),
                // prefix: const Padding(
                //   padding: EdgeInsets.only(left: 12),
                //   child: Icon(LucideIcons.send, size: 18),
                // ),
                validator: (v) {
                  if (v.isEmpty) return 'Enter address';
                  if (!v.startsWith('0x') || v.length < 10)
                    return 'Invalid address';
                  return null;
                },
              ),

              const Gap(32),

              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  height: context.height * 0.06,
                  onPressed: _sendCrypto,
                  backgroundColor: const Color(0xFF00D09C),
                  hoverBackgroundColor: const Color(0xFF00B386),
                  child: Text(
                    'Send',
                    style: theme.textTheme.h4.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Gap(40),
      ],
    ).paddingSymmetric(horizontal: 30, vertical: context.height * 0.03);
  }

  void _sendCrypto() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    // final address = _addressController.text.trim();

    if (amount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      }
      return;
    }
  }
}
