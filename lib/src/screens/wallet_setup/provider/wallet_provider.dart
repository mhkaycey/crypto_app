// Add this to your notifier file or create a new one
import 'package:crypto_app/src/core/provider/shared_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class WalletState {
  final double amount;
  final String walletName;

  WalletState({required this.amount, required this.walletName});

  WalletState copyWith({double? amount, String? walletName}) {
    return WalletState(
      amount: amount ?? this.amount,
      walletName: walletName ?? this.walletName,
    );
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier(ref);
});

class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;

  WalletNotifier(this.ref) : super(WalletState(amount: 0.0, walletName: '')) {
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final service = ref.read(sharedPreferenceServiceProvider);
    state = WalletState(
      amount: service.getAmount(),
      walletName: service.getWalletName(),
    );
  }

  Future<void> createWallet(String walletName) async {
    final service = ref.read(sharedPreferenceServiceProvider);
    await service.saveWalletName(walletName);
    state = state.copyWith(walletName: walletName);
  }

  Future<void> addAmount(double amount) async {
    final service = ref.read(sharedPreferenceServiceProvider);
    await service.addAmount(amount);
    state = state.copyWith(amount: service.getAmount());
  }

  Future<void> removeAmount(double amount) async {
    final service = ref.read(sharedPreferenceServiceProvider);
    await service.removeAmount(amount);
    state = state.copyWith(amount: service.getAmount());
  }

  // Helper getters
  double get currentAmount => state.amount;
  String get currentWalletName => state.walletName;
}
