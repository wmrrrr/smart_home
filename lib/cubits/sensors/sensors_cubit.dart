import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/core/services/mqtt_service.dart';

typedef SensorMap = Map<String, SensorReading>;

class SensorsCubit extends Cubit<SensorMap> {
  SensorsCubit() : super({}) {
    _connect();
  }

  final _mqtt = MqttService.instance;
  StreamSubscription<SensorReading>? _sub;

  Future<void> _connect() async {
    await _mqtt.connect();
    _sub = _mqtt.readings.listen((reading) {
      if (!isClosed) emit({...state, reading.topic: reading});
    });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    _mqtt.disconnect();
    return super.close();
  }
}
