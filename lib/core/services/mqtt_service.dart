import 'dart:async';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SensorReading {
  const SensorReading({
    required this.topic,
    required this.value,
    required this.unit,
  });

  final String topic;
  final String value;
  final String unit;
}

class MqttService {
  MqttService._();

  static final MqttService instance = MqttService._();

  static const _broker = 'broker.emqx.io';
  static const _port = 1883;
  static const _clientId = 'smart_home_flutter_client';

  MqttServerClient? _client;
  final _controller = StreamController<SensorReading>.broadcast();

  Stream<SensorReading> get readings => _controller.stream;
  bool get isConnected => _client?.connectionStatus?.state == MqttConnectionState.connected;

  // Fallback simulated readings when broker is unreachable
  Timer? _simulationTimer;

  Future<void> connect() async {
    _client = MqttServerClient.withPort(_broker, _clientId, _port)
      ..logging(on: false)
      ..keepAlivePeriod = 30
      ..connectTimeoutPeriod = 5000
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected;

    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('${_clientId}_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      await _client!.connect();
      if (isConnected) {
        _subscribeToTopics();
        _client!.updates?.listen(_handleMessages);
      }
    } on Exception {
      _startSimulation();
    }
  }

  void _onConnected() => _simulationTimer?.cancel();

  void _onDisconnected() => _startSimulation();

  void _subscribeToTopics() {
    const topics = [
      'smarthome/temperature',
      'smarthome/humidity',
      'smarthome/pressure',
    ];
    for (final topic in topics) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void _handleMessages(final List<MqttReceivedMessage<MqttMessage>>? messages) {
    if (messages == null) return;
    for (final msg in messages) {
      final pub = msg.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        pub.payload.message,
      );
      final topic = msg.topic;
      _controller.add(_buildReading(topic, payload));
    }
  }

  SensorReading _buildReading(final String topic, final String value) {
    if (topic.contains('temperature')) {
      return SensorReading(topic: topic, value: value, unit: '°C');
    } else if (topic.contains('humidity')) {
      return SensorReading(topic: topic, value: value, unit: '%');
    } else {
      return SensorReading(topic: topic, value: value, unit: 'hPa');
    }
  }

  void _startSimulation() {
    final rand = Random();
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final temp = (18 + rand.nextInt(14)).toString();
      final hum = (40 + rand.nextInt(30)).toString();
      final press = (1010 + rand.nextInt(15)).toString();
      _controller
        ..add(SensorReading(topic: 'smarthome/temperature', value: temp, unit: '°C'))
        ..add(SensorReading(topic: 'smarthome/humidity', value: hum, unit: '%'))
        ..add(SensorReading(topic: 'smarthome/pressure', value: press, unit: 'hPa'));
    });
  }

  void disconnect() {
    _simulationTimer?.cancel();
    _client?.disconnect();
  }
}
