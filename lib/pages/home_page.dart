import 'package:flutter/material.dart';
import 'package:my_project/widgets/background_widget.dart';
import 'package:my_project/widgets/menu_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLampOn = false;
  double lampColor = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lamp'),
        leading: const MenuButtonWidget(),
      ),
      body: BackgroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.lightbulb,
              size: 100,
              color: isLampOn ? Colors.yellow : Colors.grey,
            ),
            Switch(
              value: isLampOn,
              onChanged: (value) {
                setState(() => isLampOn = value);
              },
            ),
            Slider(
              value: lampColor,
              onChanged: (value) {
                setState(() => lampColor = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
