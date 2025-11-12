import 'package:crypto_app/src/screens/home/view.dart';
import 'package:crypto_app/src/screens/market/view.dart';

import 'package:crypto_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const CoinListScreen(),
    const MarketScreen(),
    const Center(child: Text('Settings')),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'title': 'Home', 'icon': LucideIcons.layoutDashboard},
    {'title': 'Market', 'icon': LucideIcons.shoppingBag},
    {'title': 'Settings', 'icon': LucideIcons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _navItems[_selectedIndex]['title'] as String,
            ).bold().size(context.width * 0.05).animateOpacity(visible: true),
            IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bell)),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
          child: IndexedStack(index: _selectedIndex, children: _pages),
        ),
      ),
      floatingActionButton: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_navItems.length, (i) {
            return BottomNavWidget(
              isSelected: _selectedIndex == i,
              // selectedIndex: _selectedIndex,
              title: _navItems[i]['title'] as String,
              icon: _navItems[i]['icon'] as IconData,
              onTap: () => setState(() => _selectedIndex = i),
            );
          }),
        ),
      ),
    );
  }
}

class BottomNavWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final int? selectedIndex;
  final VoidCallback onTap;
  const BottomNavWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
    this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          shape: isSelected ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: isSelected ? BorderRadius.circular(29) : null,
          color: Colors.white60.withValues(alpha: isSelected ? 1 : 0.5),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(icon, color: Colors.black).onTap(onTap),

            if (isSelected)
              Text(
                title,
                style: ShadTheme.of(context).textTheme.muted,
              ).color(isSelected ? Colors.black : Colors.black).animate(),
          ],
        ),
      ).animateSize(visible: isSelected),
    );
  }
}
