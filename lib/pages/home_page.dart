import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/connectivity_service.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:my_project/widgets/background_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLampOn = false;
  double lampColor = 0.5;
  String power = 'Очікування...';
  bool isConnected = true;

  final MqttService _mqttService = MqttService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _setupConnectivity();
    _connectToMqtt();
  }

void _setupConnectivity() async {
  isConnected = await _connectivityService.isConnected();
  if (!mounted) return;
  setState(() {});

  _connectivityService.connectivityStream.listen((status) {
    if (!mounted) return;
    setState(() {
      isConnected = status != ConnectivityResult.none;
    });
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Втрачено підключення до Інтернету')),
      );
    }
  });
}


  void _connectToMqtt() async {
    await _mqttService.connect((data) {
      setState(() {
        power = '$data W';
      });
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Smart Lamp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              isConnected ? 'Підключено до Інтернету' : 'Немає Інтернету',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Потужнісь: $power',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            Icon(
              Icons.lightbulb,
              size: 100,
              color: isLampOn ? Colors.yellow : Colors.grey,
            ),
            Switch(
              value: isLampOn,
              onChanged: (value) {
                if (!isConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Немає Інтернету')),
                  );
                  return;
                }
                setState(() => isLampOn = value);
              },
            ),
            Slider(
              value: lampColor,
              onChanged: (value) {
                if (!isConnected) return;
                setState(() => lampColor = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
