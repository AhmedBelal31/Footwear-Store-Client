// // import 'package:flutter/material.dart';
// // import '../../../../utils/styles.dart';
// // import '../../../../utils/widgets/custom_text_field.dart';
// //
// // class RegisterScreen extends StatelessWidget {
// //   const RegisterScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: Colors.blueGrey[50],
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text(
// //               'Create Your Account  !',
// //               style: TextStyle(
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //                 color: AppStyles.kPrimaryColor,
// //               ),
// //             ),
// //             const SizedBox(height: 30),
// //             const CustomTextField(
// //               labelText: 'Your Name ',
// //               hintText: 'Enter Your Name ',
// //               prefixIcon: Icons.person,
// //             ),
// //             const SizedBox(height: 20),
// //             const CustomTextField(
// //               labelText: 'Mobile Number',
// //               hintText: 'Enter Your Mobile Number ',
// //               prefixIcon: Icons.phone_android,
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.white,
// //                 backgroundColor: AppStyles.kPrimaryColor,
// //               ),
// //               onPressed: () {},
// //               child: const Text('  Send OTP  '),
// //             ),
// //             TextButton(
// //               onPressed: () {},
// //               child: const Text('Login'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:footwear_store_client/core/modules/home_module/presentation/screens/home_screen.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
// import '../../../../utils/styles.dart';
// import '../../../../utils/widgets/custom_text_field.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   var _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//
//   final TextEditingController _phoneController = TextEditingController();
//
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (context) => AuthCubit(FirebaseAuth.instance),
//         child: BlocConsumer<AuthCubit, AuthStates>(
//           listener: (context, state) {
//             if (state is AuthLoggedInState) {
//               // Navigator.pushReplacement(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => const HomeScreen(),
//               //     ));
//             } else if (state is AuthErrorState) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//               print(state.message);
//             }
//           },
//           builder: (context, state) {
//             return Form(
//               key: _formKey,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.blueGrey[50],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Create Your Account  !',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: AppStyles.kPrimaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     CustomTextField(
//                       controller: _nameController,
//                       keyboardType: TextInputType.text,
//                       labelText: 'Your Name ',
//                       hintText: 'Enter Your Name ',
//                       prefixIcon: Icons.person,
//                       autovalidateMode: autovalidateMode,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Name is required ";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     CustomTextField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       labelText: 'Mobile Number',
//                       hintText: 'Enter Your Mobile Number ',
//                       prefixIcon: Icons.phone_android,
//                       autovalidateMode: autovalidateMode,
//                       validator: validateEgyptPhoneNumber,
//                     ),
//                     const SizedBox(height: 20),
//                     if (state is AuthCodeSentState || state is AuthErrorState)
//                       CustomTextField(
//                         controller: _otpController,
//                         keyboardType: TextInputType.phone,
//                         labelText: 'OTP',
//                         hintText: 'Enter OTP',
//                         validator: validateOTP,
//                         autovalidateMode: autovalidateMode,
//                         prefixIcon: Icons.message,
//                       ),
//                     const SizedBox(height: 20),
//                     if (state is AuthLoggedInState)
//                       CustomTextField(
//                         controller: _passwordController,
//                         keyboardType: TextInputType.visiblePassword,
//                         labelText: 'Password',
//                         hintText: 'Enter Password',
//                         validator: passwordValidator,
//                         autovalidateMode: autovalidateMode,
//                         prefixIcon: Icons.message,
//                       ),
//                     const SizedBox(height: 20),
//                     if (state is AuthLoadingState)
//                       const Center(
//                         child: CircularProgressIndicator(
//                           color: AppStyles.kPrimaryColor,
//                         ),
//                       ),
//                     if (state is! AuthLoadingState)
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: AppStyles.kPrimaryColor,
//                         ),
//                         onPressed: () {
//                           validateForm(state, context);
//                         },
//                         child: Text(
//                           state is AuthCodeSentState
//                               ? 'Verify OTP'
//                               : 'Send OTP',
//                         ),
//                       ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text('Login'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void validateForm(AuthStates state, BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (state is AuthCodeSentState) {
//         context.read<AuthCubit>().verifyOtp(_otpController.text);
//
//       } else {
//         context
//             .read<AuthCubit>()
//             .registerWithPhoneNumber(_phoneController.text);
//       }
//
//
//     } else {
//       setState(() {
//         autovalidateMode = AutovalidateMode.always;
//       });
//     }
//   }
//
//   String? validateEgyptPhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     }
//
//     // Remove all spaces and dashes
//     value = value.replaceAll(RegExp(r'\s+|-'), '');
//
//     // Regex for Egyptian phone number
//     final RegExp regex =
//         RegExp(r'^(010|011|012|015)\d{8}$|^\+201(0|1|2|5)\d{8}$');
//
//     if (!regex.hasMatch(value)) {
//       return 'Enter a valid Egyptian phone number';
//     }
//
//     return null;
//   }
//
//   String? validateOTP(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'OTP is required';
//     }
//
//     // Regex to match exactly 6 digits
//     final RegExp regex = RegExp(r'^\d{6}$');
//
//     if (!regex.hasMatch(value)) {
//       return 'Enter a valid 6-digit OTP';
//     }
//
//     return null;
//   }
//
//   String? passwordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters long';
//     }
//
//     bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
//     bool hasLowercase = value.contains(RegExp(r'[a-z]'));
//     bool hasDigit = value.contains(RegExp(r'[0-9]'));
//     bool hasSpecialCharacter =
//         value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
//
//     if (!hasUppercase) {
//       return 'Password must contain at least one uppercase letter';
//     }
//
//     if (!hasLowercase) {
//       return 'Password must contain at least one lowercase letter';
//     }
//
//     if (!hasDigit) {
//       return 'Password must contain at least one digit';
//     }
//
//     if (!hasSpecialCharacter) {
//       return 'Password must contain at least one special character';
//     }
//
//     return null;
//   }
// }

//
// //With Email And Password
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:footwear_store_client/core/modules/home_module/presentation/screens/home_screen.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
// import '../../../../utils/styles.dart';
// import '../../../../utils/widgets/custom_text_field.dart';
// import '../functions/validate_password.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   static const screenRoute = 'registerScreen' ;
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   var _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _otpController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthCubit, AuthStates>(
//         listener: (context, state) {
//           if (state is AuthLoggedInState) {
//             context.read<AuthCubit>().createAccount(
//               userName: _nameController.text,
//               password: _passwordController.text,
//               phoneNumber: _phoneController.text,
//             );
//           } else if (state is CreateAccountSuccessfullyState) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomeScreen(),
//               ),
//             );
//           } else if (state is AuthErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             print(state.message);
//           } else if (state is CreateAccountFailureState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             print(state.errorMessage);
//           }
//         },
//         builder: (context, state) {
//           return Form(
//             key: _formKey,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey[50],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Create Your Account  !',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: AppStyles.kPrimaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   CustomTextField(
//                     controller: _nameController,
//                     keyboardType: TextInputType.text,
//                     labelText: 'Your Name ',
//                     hintText: 'Enter Your Name ',
//                     prefixIcon: Icons.person,
//                     autovalidateMode: autovalidateMode,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Name is required ";
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     labelText: 'Mobile Number',
//                     hintText: 'Enter Your Mobile Number ',
//                     prefixIcon: Icons.phone_android,
//                     autovalidateMode: autovalidateMode,
//                     validator: validateEgyptPhoneNumber,
//                   ),
//                   CustomTextField(
//                     labelText: 'Password',
//                     hintText: 'Enter Your Password ',
//                     controller: _passwordController,
//                     prefixIcon: Icons.lock,
//                     autovalidateMode: autovalidateMode,
//                     obscureText: context.read<AuthCubit>().isPasswordShown,
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         context.read<AuthCubit>().changePasswordIcon();
//                       },
//                       icon: Icon(context.read<AuthCubit>().passwordIcon),
//                     ),
//                     keyboardType: TextInputType.visiblePassword,
//                     validator: validatePassword,
//                   ),
//                   const SizedBox(height: 20),
//                   if (state is AuthCodeSentState || state is AuthErrorState)
//                     CustomTextField(
//                       controller: _otpController,
//                       keyboardType: TextInputType.phone,
//                       labelText: 'OTP',
//                       hintText: 'Enter OTP',
//                       validator: validateOTP,
//                       autovalidateMode: autovalidateMode,
//                       prefixIcon: Icons.message,
//                     ),
//                   const SizedBox(height: 20),
//                   if (state is AuthLoggedInState)
//                     CustomTextField(
//                       controller: _passwordController,
//                       keyboardType: TextInputType.visiblePassword,
//                       labelText: 'Password',
//                       hintText: 'Enter Password',
//                       validator: validatePassword,
//                       autovalidateMode: autovalidateMode,
//                       prefixIcon: Icons.lock,
//                     ),
//                   const SizedBox(height: 20),
//                   if (state is AuthLoadingState)
//                     const Center(
//                       child: CircularProgressIndicator(
//                         color: AppStyles.kPrimaryColor,
//                       ),
//                     ),
//                   if (state is! AuthLoadingState)
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: AppStyles.kPrimaryColor,
//                       ),
//                       onPressed: () {
//                         validateForm(state, context);
//                       },
//                       child: Text(
//                         state is AuthCodeSentState
//                             ? 'Verify OTP'
//                             : 'Send OTP',
//                       ),
//                     ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text('Login'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void validateForm(AuthStates state, BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (state is AuthCodeSentState) {
//         context.read<AuthCubit>().verifyOtp(_otpController.text);
//       } else {
//         context.read<AuthCubit>().registerWithPhoneNumber(_phoneController.text);
//       }
//     } else {
//       setState(() {
//         autovalidateMode = AutovalidateMode.always;
//       });
//     }
//   }
//
//   String? validateEgyptPhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     }
//
//     // Remove all spaces and dashes
//     value = value.replaceAll(RegExp(r'\s+|-'), '');
//
//     // Regex for Egyptian phone number
//     final RegExp regex =
//     RegExp(r'^(010|011|012|015)\d{8}$|^\+201(0|1|2|5)\d{8}$');
//
//     if (!regex.hasMatch(value)) {
//       return 'Enter a valid Egyptian phone number';
//     }
//
//     return null;
//   }
//
//   String? validateOTP(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'OTP is required';
//     }
//
//     // Regex to match exactly 6 digits
//     final RegExp regex = RegExp(r'^\d{6}$');
//
//     if (!regex.hasMatch(value)) {
//       return 'Enter a valid 6-digit OTP';
//     }
//
//     return null;
//   }
//
//
//
//
//
//
//
//
//
// }

//For Testing
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/home_module/presentation/screens/home_screen.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/reset_password_screen.dart';
import 'package:footwear_store_client/core/utils/widgets/awesome_snack_bar.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../functions/validate_egypt_phone_number.dart';
import '../functions/validate_email.dart';
import '../functions/validate_otp.dart';
import '../functions/validate_password.dart';
import 'verify_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const screenRoute = 'registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is CreateAccountSuccessfullyState) {
            context.read<AuthCubit>().sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context
                .read<AuthCubit>()
                .registerWithPhoneNumber(_phoneController.text);
          }
          if (state is PhoneNumberExistState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Phone number is already in use by another account.'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is SaveAccountInformationFailureState) {
            final failureSnackBar =
                customFailureSnackBar(errorMessage: state.errorMessage);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(failureSnackBar);
          }
          if (state is CreateAccountFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
            print(state.errorMessage);
          }
          if (state is CodeSentSuccessState) {
            Navigator.pushNamed(
              context,
              VerifyOtpScreen.screenRoute,
              arguments: _phoneController.text,
            );
          }
          if (state is ResetPasswordViaEmailFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is RegisterWithPhoneNumberFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pushReplacementNamed(
              context,
              LoginScreen.screenRoute,
            );

          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
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
                        autovalidateMode: autovalidateMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required ";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        labelText: 'Email-Address',
                        hintText: 'Enter Your Email-Address ',
                        prefixIcon: Icons.email,
                        controller: _emailController,
                        autovalidateMode: autovalidateMode,
                        validator: validateEmail,
                      ),
                      CustomTextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        labelText: 'Phone Number',
                        hintText: 'Enter Your Phone Number ',
                        prefixIcon: Icons.phone_android,
                        autovalidateMode: autovalidateMode,
                        // validator: validateEgyptPhoneNumber,
                        validator: validateEgyptPhoneNumber,
                      ),
                      CustomTextField(
                        labelText: 'Password',
                        hintText: 'Enter Your Password ',
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        autovalidateMode: autovalidateMode,
                        obscureText:
                            context.read<AuthCubit>().isRegisterPasswordShown,
                        suffixIcon: IconButton(
                          onPressed: () {
                            context
                                .read<AuthCubit>()
                                .changeRegisterPasswordIcon();
                          },
                          icon: Icon(
                              context.read<AuthCubit>().registerPasswordIcon),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      if (state is RegisterWithPhoneNumberLoadingState ||
                          state is CreateAccountLoadingState ||
                          state is SendEmailVerificationLoadingState ||
                          state is SaveAccountInformationLoadingState ||
                          state is SendEmailVerificationSuccessfullyState

                      )
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppStyles.kPrimaryColor,
                          ),
                        ),
                      if (state is! RegisterWithPhoneNumberLoadingState &&
                          state is! SaveAccountInformationLoadingState &&
                          state is! CreateAccountLoadingState  &&
                           state is! SendEmailVerificationLoadingState
                      )
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
                              validateForm(state, context);
                            },
                            child: Text('Register'),
                          ),
                        ),
                      SizedBox(height:20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.screenRoute);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void validateForm(AuthStates state, BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().createAccount(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            phoneNumber: _phoneController.text,
          );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
