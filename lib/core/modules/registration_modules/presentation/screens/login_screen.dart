// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
// import 'package:footwear_store_client/core/utils/styles.dart';
// import '../../../../utils/widgets/custom_text_field.dart';
// import '../../../home_module/presentation/screens/home_screen.dart';
// import '../functions/validate_email.dart';
// import '../functions/validate_password.dart';
// import 'register_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   static const screenRoute = 'loginScreen';
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   var _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<AuthCubit, AuthStates>(
//         builder: (context, state) {
//           return Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                     //color: Colors.blueGrey[50],
//                     ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Welcome Back !',
//                       style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: AppStyles.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 30),
//                     CustomTextField(
//                       labelText: 'Email-Address',
//                       hintText: 'Enter Your Email-Address ',
//                       prefixIcon: Icons.email,
//                       controller: _emailController,
//                       autovalidateMode: autovalidateMode,
//                       validator: validateEmail,
//                     ),
//                     CustomTextField(
//                       labelText: 'Password',
//                       hintText: 'Enter Your Password ',
//                       controller: _passwordController,
//                       prefixIcon: Icons.lock,
//                       autovalidateMode: autovalidateMode,
//                       obscureText: context.read<AuthCubit>().isPasswordShown,
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           context.read<AuthCubit>().changePasswordIcon();
//                         },
//                         icon: Icon(context.read<AuthCubit>().passwordIcon),
//                       ),
//                       keyboardType: TextInputType.visiblePassword,
//                       validator: validatePassword,
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: AppStyles.kPrimaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             )),
//                         onPressed: () {
//                           validateForm(context);
//                         },
//                         child: const Text('Login'),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => RegisterScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text('Register new account ?'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void validateForm(BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Navigator.of(context).pushNamed(HomeScreen.screenRoute);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Hello Body')));
//     } else {
//       setState(() {
//         autovalidateMode = AutovalidateMode.always;
//       });
//     }
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import '../../../../utils/widgets/awesome_snack_bar.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../home_module/presentation/screens/home_screen.dart';
import '../functions/validate_email.dart';
import '../functions/validate_password.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const screenRoute = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LoginSuccessfullyState) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.screenRoute);
            _emailController.clear();
            _passwordController.clear();
            final successSnackBar = customSuccessSnackBar(
              successMessage: 'Login successful! Welcome back!',
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(successSnackBar);
          } else if (state is LoginFailureState) {
            final failureSnackBar =
                customFailureSnackBar(errorMessage: state.errorMessage);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(failureSnackBar);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    //color: Colors.blueGrey[50],
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
                    const SizedBox(height: 30),
                    CustomTextField(
                      labelText: 'Email-Address',
                      hintText: 'Enter Your Email-Address ',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      autovalidateMode: autovalidateMode,
                      validator: validateEmail,
                    ),
                    CustomTextField(
                      labelText: 'Password',
                      hintText: 'Enter Your Password ',
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                      autovalidateMode: autovalidateMode,
                      obscureText:
                          context.read<AuthCubit>().isLoginPasswordShown,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<AuthCubit>().changeLoginPasswordIcon();
                        },
                        icon: Icon(context.read<AuthCubit>().loginPasswordIcon),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 20),
                    if (state is LoginLoadingState)
                      Center(
                          child: CircularProgressIndicator(
                              color: AppStyles.kPrimaryColor)),
                    if (state is! LoginLoadingState)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppStyles.kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            validateForm(
                              context,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Register new account ?'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void validateForm(BuildContext context,
      {required String email, required String password}) {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .loginWithEmailAndPassword(email: email, password: password);
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
