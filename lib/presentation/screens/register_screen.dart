import 'package:flutter/material.dart';

import '../../core/utils/styles.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Your Account  !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppStyles.kPrimaryColor,
              ),
            ),
            const SizedBox(height: 30),
            const CustomTextField(
              labelText: 'Your Name ',
              hintText: 'Enter Your Name ',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              labelText: 'Mobile Number',
              hintText: 'Enter Your Mobile Number ',
              prefixIcon: Icons.phone_android,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppStyles.kPrimaryColor,
              ),
              onPressed: () {},
              child: const Text('  Send OTP  '),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
