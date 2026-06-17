import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/core/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider() {
    _init();
  }

  final _service = ConnectivityService.instance;
  bool _connected = true;
  StreamSubscription<bool>? _sub;

  bool get isConnected => _connected;

  Future<void> _init() async {
    _connected = await _service.isConnected();
    notifyListeners();
    _sub = _service.onStatusChange.listen((online) {
      _connected = online;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
