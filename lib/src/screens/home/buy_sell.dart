import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SendReceiveScreen extends ConsumerStatefulWidget {
  const SendReceiveScreen({super.key});

  @override
  ConsumerState<SendReceiveScreen> createState() => _SendReceiveScreenState();
}

class _SendReceiveScreenState extends ConsumerState<SendReceiveScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();

  // Mock wallet address (replace with real one from provider)
  static const String _mockAddress = "0x742d35Cc6634C0532925a3b8D4C9A";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _copyAddress() {
    Clipboard.setData(const ClipboardData(text: _mockAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied!'),
        backgroundColor: Color(0xFF00D09C),
      ),
    );
  }

  void _sendCrypto() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final address = _addressController.text.trim();

    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    // TODO: Call your send transaction logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sending $amount ETH to $address...')),
    );

    _amountController.clear();
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send & Receive'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00D09C),
          labelColor: const Color(0xFF00D09C),
          unselectedLabelColor: theme.colorScheme.mutedForeground,
          tabs: const [
            Tab(icon: Icon(LucideIcons.arrowUp), text: 'Send'),
            Tab(icon: Icon(LucideIcons.arrowDown), text: 'Receive'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ===================== SEND TAB =====================
          _buildSendTab(theme),

          // =================== RECEIVE TAB ===================
          _buildReceiveTab(theme),
        ],
      ),
    );
  }

  Widget _buildSendTab(ShadThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.06),
      child: Column(
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
                  '\$5,000.40',
                  style: theme.textTheme.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00D09C),
                  ),
                ),
                Text('12.34 ETH', style: theme.textTheme.muted),
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
                    onPressed: _sendCrypto,
                    backgroundColor: const Color(0xFF00D09C),
                    hoverBackgroundColor: const Color(0xFF00B386),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildReceiveTab(ShadThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.06),
      child: Column(
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
              data: _mockAddress,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
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
                    _mockAddress,
                    style: theme.textTheme.muted.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _copyAddress,
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
      ),
    );
  }
}
