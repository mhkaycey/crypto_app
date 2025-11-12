import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/src/screens/home/model/coin_data.dart';
import 'package:crypto_app/src/screens/widgets/mini_sparkline.dart';
import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class CoinListWidget extends StatelessWidget {
  const CoinListWidget({
    super.key,
    required this.coin,
    required this.price,
    required this.isPositive,
    required this.change24h,
  });

  final CryptoCoin coin;
  final num? price;
  final bool isPositive;
  final num? change24h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          CachedNetworkImage(
            imageUrl: coin.image ?? '',
            width: 48,
            height: 48,
            placeholder: (_, __) => Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ).rounded(24),

          const SizedBox(width: 12),

          // Name & Symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  coin.symbol!.toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${price?.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  MiniSparkline(
                    data: coin.sparklineIn7d?.price ?? [],
                    isPositive: isPositive,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive
                        ? const Color(0xFF00D09C)
                        : const Color(0xFFFF4444),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '' : ''}${change24h?.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive
                          ? const Color(0xFF00D09C)
                          : const Color(0xFFFF4444),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
