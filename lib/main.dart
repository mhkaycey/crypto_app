import 'package:crypto_app/src/screens/dashboard.dart';
import 'package:crypto_app/src/screens/wallet_setup/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_app/src/core/provider/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      retry: (retryCount, error) => null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadSlateColorScheme.dark(),
      ),
      // themeMode: ThemeMode.dark,
      // darkTheme: ShadThemeData(
      //   brightness: Brightness.dark,
      //   colorScheme: ShadSlateColorScheme.dark(),
      // ),
      // appBuilder: (context) => MaterialApp(
      //   theme: Theme.of(context),
      //   builder: (context, child) => ShadAppBuilder(child: child!),
      //   home: const DashBoardScreen(),
      // ),
      home: Consumer(
        builder: (context, ref, child) =>
            ref.watch(sharedPreferenceServiceProvider).isWalletCreated
            ? const DashBoardScreen()
            : const WalletSetup(),
      ),
    );
  }
}
