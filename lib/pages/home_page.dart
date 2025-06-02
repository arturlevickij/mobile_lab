import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth_cubit.dart';
import 'package:my_project/cubit/lamp_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lamp Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/qr');
              if (context.mounted && result != null) {
                // лог або будь-яка інша обробка
                debugPrint('[HomePage] QR результат: $result');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('QR: $result')),
                );
              }
            },
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await context.read<AuthCubit>().logOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Не вдалося вийти з облікового запису'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<LampCubit, bool>(
          builder: (context, isLampOn) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLampOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 100,
                  color: isLampOn ? Colors.yellow : Colors.grey,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<LampCubit>().toggleLamp();
                  },
                  child: Text(isLampOn ? 'Вимкнути' : 'Увімкнути'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
