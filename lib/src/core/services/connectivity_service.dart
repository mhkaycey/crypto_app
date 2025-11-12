// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast();

    _subscription ??= _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _isConnectedFromResults(results);
      if (!_controller!.isClosed) {
        _controller!.add(isConnected);
      }
    });

    return _controller!.stream;
  }

  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnectedFromResults(results);
    } catch (e) {
      log('Error checking connectivity: $e');
      return false;
    }
  }

  bool _isConnectedFromResults(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    _controller = null;
  }
}
