import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/verify_otp_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import '../../../../../const.dart';
import '../../../../utils/styles.dart';
import '../controller/auth_cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const screenRoute = 'resetPasswordScreen';

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
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is PhoneNumberNotExistState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No Account With This Phone Number'),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is PhoneNumberExistState) {
            context.read<AuthCubit>().registerWithPhoneNumber(phoneNumber!);
          }

          if (state is CodeSentSuccessState) {
            Navigator.pushNamed(
              context,
              VerifyOtpScreen.screenRoute,
              arguments: phoneNumber,
            );
          }
          if (state is RegisterWithPhoneNumberFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
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
                    },
                  ),
                  SizedBox(height: 20),
                  if (state is RegisterWithPhoneNumberLoadingState)
                    Center(
                        child: CircularProgressIndicator(
                            color: AppStyles.kPrimaryColor)),
                  if (state is! RegisterWithPhoneNumberLoadingState)
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
                          FocusScope.of(context).unfocus();
                          if (phoneNumber != null && phoneNumber!.isNotEmpty) {
                            String formattedPhoneNumber =
                                phoneNumber!.substring(2);
                            print(formattedPhoneNumber);
                            // context
                            //     .read<AuthCubit>()
                            //     .validatePhoneNumber(formattedPhoneNumber);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please enter a valid phone number')),
                            );
                          }
                        },
                        child: Text('Reset Password'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
