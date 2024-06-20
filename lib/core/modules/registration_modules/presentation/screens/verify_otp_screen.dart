// import 'package:flutter/material.dart';
//
// class VerifyOtpScreen extends StatelessWidget {
//
//   const VerifyOtpScreen({super.key});
//   static const screenRoute = 'verifyOtpScreen';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify OTP'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen();

  static const screenRoute = 'verifyOtpScreen';
  late String otpCode;

  void _login(BuildContext context) {
    // BlocProvider.of<AuthCubit>(context).submitOTP(otpCode);
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          // if (state is Loading) {
          //   showProgressIndicator(context);
          // }
          //
          // if (state is PhoneOTPVerified) {
          //   Navigator.pop(context);
          //   NavigateAndRep(context,changepassword());
          // }
          //
          // if (state is ErrorOccurred) {
          //   //Navigator.pop(context);
          //   String errorMsg = (state).errorMsg;
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(errorMsg),
          //       backgroundColor: Colors.black,
          //       duration: Duration(seconds: 3),
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/images/otp.json',
                        height: 180,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Verify Your Phone Number ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text:
                              "Enter your 6 digit code numbers sent to you at ",
                          style: TextStyle(fontSize: 16, color: Colors.black , height: 1.5),
                          children: [
                            TextSpan(
                              text: "$phoneNumber",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppStyles.kPrimaryColor,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildPinCodeFields(context),
                    SizedBox(
                      height: 20,
                    ),
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
                          // showProgressIndicator(context);
                          // _login(context);
                        },
                        child: Text("VERIFY" ,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildPinCodeFields(context) {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: false,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeFillColor: Colors.blue.withOpacity(.1),
          selectedFillColor: Colors.grey[100],
          inactiveColor: AppStyles.kPrimaryColor,
          inactiveFillColor: Colors.white,
          selectedColor: AppStyles.kPrimaryColor,
          activeColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        onCompleted: (code) {
          otpCode = code;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
