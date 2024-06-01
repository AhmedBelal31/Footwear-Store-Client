import 'package:flutter/material.dart';
import 'package:footwear_store_client/core/utils/styles.dart';

import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              'Welcome Back !',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.kPrimaryColor),
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              hintText: 'Mobile Number',
              prefixIcon: Icons.phone_android,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppStyles.kPrimaryColor,
              ),
              onPressed: () {},
              child: const Text('  Login  '),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Register new account ?'),
            ),
          ],
        ),
      ),
    );
  }
}
