import 'package:crypto_app/src/screens/dashboard.dart';
import 'package:crypto_app/src/screens/wallet_setup/provider/wallet_provider.dart';
import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WalletSetup extends ConsumerStatefulWidget {
  const WalletSetup({super.key});

  @override
  ConsumerState<WalletSetup> createState() => _WalletSetupState();
}

class _WalletSetupState extends ConsumerState<WalletSetup> {
  final _formKey = GlobalKey<ShadFormState>();
  final _walletNameController = TextEditingController();

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  void _createWallet() async {
    final service = ref.read(walletProvider.notifier);
    // await service.saveWalletName(_walletNameController.text);

    if (_formKey.currentState?.validate() ?? false) {
      final walletName = _walletNameController.text;
      await service.createWallet(walletName);
      await service.addAmount(0.0);

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast(
            backgroundColor: Colors.green,
            description: Text('Wallet created successfully!'),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashBoardScreen()),
        );
        // Navigate to dashboard or next step
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    // final service = ref.read(sharedPreferenceServiceProvider);

    return Scaffold(
      // backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.06,
                vertical: 20,
              ),
              child: Column(
                children: [
                  const Gap(40),

                  // Logo / Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.wallet,
                      size: 48,
                      color: const Color(0xFF00D09C),
                    ),
                  ),

                  const Gap(24),

                  // Title
                  Text(
                    'Create Your Wallet',
                    style: theme.textTheme.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).center(),

                  const Gap(8),

                  // Subtitle
                  Text(
                    'Give your wallet a name to get started',
                    style: theme.textTheme.muted,
                    textAlign: TextAlign.center,
                  ).center(),

                  const Gap(40),

                  // Form
                  ShadForm(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Wallet Name Input
                        ShadInputFormField(
                          controller: _walletNameController,
                          label: const Text('Wallet Name'),
                          placeholder: const Text('e.g., My Crypto Wallet'),
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'Please enter a wallet name';
                            }
                            if (v.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                          decoration: ShadDecoration(
                            // prefix: const Padding(
                            //   padding: EdgeInsets.only(left: 12),
                            //   child: Icon(LucideIcons.user, size: 18),
                            // ),
                          ),
                        ),

                        const Gap(32),

                        // Create Button
                        SizedBox(
                          width: double.infinity,
                          child: ShadButton(
                            onPressed: _createWallet,
                            backgroundColor: const Color(0xFF00D09C),
                            hoverBackgroundColor: const Color(0xFF00B386),
                            child: const Text(
                              'Create Wallet',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const Gap(16),

                        // Import Option
                        SizedBox(
                          width: double.infinity,
                          child: ShadButton.outline(
                            onPressed: () {},
                            child: const Text('Import Existing Wallet'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Security Note
                  Text(
                    'Your wallet is encrypted and stored securely on your device.',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 20),

                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
