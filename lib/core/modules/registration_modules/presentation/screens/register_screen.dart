// import 'package:flutter/material.dart';
// import '../../../../utils/styles.dart';
// import '../../../../utils/widgets/custom_text_field.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.blueGrey[50],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Create Your Account  !',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: AppStyles.kPrimaryColor,
//               ),
//             ),
//             const SizedBox(height: 30),
//             const CustomTextField(
//               labelText: 'Your Name ',
//               hintText: 'Enter Your Name ',
//               prefixIcon: Icons.person,
//             ),
//             const SizedBox(height: 20),
//             const CustomTextField(
//               labelText: 'Mobile Number',
//               hintText: 'Enter Your Mobile Number ',
//               prefixIcon: Icons.phone_android,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: AppStyles.kPrimaryColor,
//               ),
//               onPressed: () {},
//               child: const Text('  Send OTP  '),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/home_module/presentation/screens/home_screen.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(FirebaseAuth.instance),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is AuthLoggedInState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              print(state.message);
            }
          },
          builder: (context, state) {
            return Container(
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
                  CustomTextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    labelText: 'Your Name ',
                    hintText: 'Enter Your Name ',
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    labelText: 'Mobile Number',
                    hintText: 'Enter Your Mobile Number ',
                    prefixIcon: Icons.phone_android,
                  ),
                  const SizedBox(height: 20),
                  if (state is AuthCodeSentState)
                    CustomTextField(
                      controller: _otpController,
                      labelText: 'OTP',
                      hintText: 'Enter OTP',
                      prefixIcon: Icons.message,
                    ),
                  const SizedBox(height: 20),
                  if (state is AuthLoadingState)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppStyles.kPrimaryColor,
                      ),
                    ),
                  if (state is! AuthLoadingState)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppStyles.kPrimaryColor,
                      ),
                      onPressed: () {
                        if (state is AuthCodeSentState) {
                          context
                              .read<AuthCubit>()
                              .verifyOtp(_otpController.text);
                        } else {
                          context.read<AuthCubit>().registerWithPhoneNumber(_phoneController.text);
                        }
                      },
                      child: Text(state is AuthCodeSentState
                          ? 'Verify OTP'
                          : 'Send OTP'),
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
