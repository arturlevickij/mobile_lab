import 'package:flutter/material.dart';
import 'package:my_project/widgets/background_widget.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/menu_button_widget.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const MenuButtonWidget(),
      ),
      
      body: BackgroundWidget(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Register',
                  onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}
