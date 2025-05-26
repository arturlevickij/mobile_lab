import 'dart:developer' as developer;

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final _client = MqttServerClient('broker.hivemq.com',
   'flutter_smartlamp_client',);

  Future<void> connect(void Function(String) onMessage) async {
    _client.port = 1883;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = () => developer.log(' MQTT Disconnected');
    _client.onConnected = () => developer.log('MQTT Connected!');

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_smartlamp_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      developer.log('Connection failed', error: e);
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _client.subscribe('sensor/power', MqttQos.atMostOnce);
      _client.updates!.listen((
        List<MqttReceivedMessage<MqttMessage>> messages,) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = 
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        onMessage(payload);
      });
    }
  }

  void disconnect() {
    _client.disconnect();
  }
}
