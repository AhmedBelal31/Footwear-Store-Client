import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/functions/validate_password.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import 'package:footwear_store_client/core/utils/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';

class UpdatePasswordScreen extends StatefulWidget {
  static const screenRoute = 'updatePasswordScreen';

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    // final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is UpdatePasswordSuccessfullyState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Password updated successfully' , style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              );
              Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.screenRoute);
            }
            if (state is UpdatePasswordFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/images/password animation.json',
                        // getRandomLottieFile(),
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'Password',
                        hintText: 'Enter Your Password ',
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        autovalidateMode: autovalidateMode,
                        obscureText: context.read<AuthCubit>().isResetPasswordShown,
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.read<AuthCubit>().changeResetPasswordIcon();
                          },
                          icon: Icon(context.read<AuthCubit>().resetPasswordIcon),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: validatePassword,
                      ),
                      SizedBox(height: 20),
                      if (state is UpdatePasswordLoadingState)
                        Center(
                            child: CircularProgressIndicator(
                          color: AppStyles.kPrimaryColor,
                        )),
                      if (state is! UpdatePasswordLoadingState)
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
                              validateForm(state ,context);

                            },
                            child: Text('Update Password'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void validateForm(AuthStates state, BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .updatePassword(_passwordController.text);
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
