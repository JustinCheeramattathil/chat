import 'package:chatos_messenger/common/widgets/custom_button.dart';
import 'package:chatos_messenger/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text('Chatos Messenger',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 30,
            ),
            Lottie.asset('assets/images/chat.json'),
            SizedBox(
              height: size.height / 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tap to continue', style: TextStyle(fontSize: 20)),
                Icon(Icons.arrow_forward),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
                text: 'CONTINUE',
                onPressed: () => navigateToLoginScreen(context))
          ],
        )),
      ),
    );
  }
}
