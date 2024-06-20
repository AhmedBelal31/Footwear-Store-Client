import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/verify_otp_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/styles.dart';
import '../controller/auth_cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const screenRoute = 'resetPasswordScreen';
  final TextEditingController _phoneController = TextEditingController();

  final List<String> lottieFiles = [
    'assets/images/phone_number.json',
    'assets/images/funny_mobile.json'
  ];

  String getRandomLottieFile() {
    final random = Random();
    return lottieFiles[random.nextInt(lottieFiles.length)];
  }

  @override
  Widget build(BuildContext context) {
    String? phoneNumber;
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Reset Password',
        //   style: TextStyle(fontSize: 16),
        // ),
      ),
      body: BlocListener<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthCodeSentState) {
            // Navigate to OTP verification screen
            Navigator.pushNamed(context, '/verify_otp',
                arguments: _phoneController.text);
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/images/phone_number.json',
                    // getRandomLottieFile(),
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'EG',
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber;
                      print(phone.completeNumber);
                    },

                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppStyles.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (phoneNumber != null) {
                          Navigator.of(context).pushNamed(
                              VerifyOtpScreen.screenRoute,
                              arguments: phoneNumber);
                        }
                      },
                      child: Text('Reset Password'),
                    ),
                  ),
                  if (context.watch<AuthCubit>().state is AuthLoadingState)
                    CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
