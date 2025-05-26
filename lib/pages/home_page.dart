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

  bool wasDisconnectedOnce = false;

  _connectivityService.connectivityStream.listen((status) {
    if (!mounted) return;

    final currentlyConnected = status != ConnectivityResult.none;

    setState(() {
      isConnected = currentlyConnected;
    });

    if (!currentlyConnected && !wasDisconnectedOnce) {
      wasDisconnectedOnce = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Втрачено підключення до Інтернету')),
      );
    }

    if (currentlyConnected) {
      wasDisconnectedOnce = false;
    }
  });
}



void _connectToMqtt() async {
  await _mqttService.connect((data) {
    final parsedPower = double.tryParse(data);
    if (parsedPower != null && parsedPower < 100) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text
          ('УВАГА: Потужність нижча за 100 W ($parsedPower W)'),),
        );
      }
    }

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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isConnected ? Colors.green.shade100 :
                 Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isConnected ? 'Підключено до Інтернету' : 'Немає Інтернету',
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/qr');
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Сканувати QR-код'),
            ),
          ],
        ),
      ),
    );
  }
}
