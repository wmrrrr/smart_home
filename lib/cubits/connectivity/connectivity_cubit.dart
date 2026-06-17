import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/core/services/connectivity_service.dart';

class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit() : super(true) {
    _init();
  }

  final _service = ConnectivityService.instance;
  StreamSubscription<bool>? _sub;

  Future<void> _init() async {
    final connected = await _service.isConnected();
    emit(connected);
    _sub = _service.onStatusChange.listen(emit);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
