import 'package:crypto_app/src/core/services/connectivity_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

final isConnectedProvider = FutureProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isConnected;
});
