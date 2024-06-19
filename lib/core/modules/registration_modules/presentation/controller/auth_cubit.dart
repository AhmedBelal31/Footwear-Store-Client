import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footwear_store_client/core/modules/registration_modules/data/models/user_model.dart';
import 'dart:io';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  final FirebaseAuth _firebaseAuth;
  String? _verificationId;

  AuthCubit(this._firebaseAuth) : super(AuthInitialState());

  ///Change Password Icon
  IconData loginPasswordIcon = Icons.visibility;
  bool isLoginPasswordShown = true;



  void changeLoginPasswordIcon() {
    isLoginPasswordShown
        ? loginPasswordIcon = Icons.visibility_off
        : loginPasswordIcon = Icons.visibility;
    isLoginPasswordShown = !isLoginPasswordShown;
    emit(ChangeLoginPasswordIconState());
  }

  IconData registerPasswordIcon = Icons.visibility;
  bool isRegisterPasswordShown = true;
  void changeRegisterPasswordIcon() {
    isRegisterPasswordShown
        ? registerPasswordIcon = Icons.visibility_off
        : registerPasswordIcon = Icons.visibility;
    isRegisterPasswordShown = !isRegisterPasswordShown;
    emit(ChangeRegisterPasswordIconState());
  }

  ///Verify Phone Number
  Future<void> registerWithPhoneNumber(String phoneNumber) async {
    emit(AuthLoadingState());
    try {
      final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
            emit(AuthLoggedInState());
          } catch (e) {
            emit(AuthErrorState(
                "Verification completed but login failed: ${_getErrorMessage(e)}"));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthErrorState(_getFirebaseAuthErrorMessage(e)));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(AuthCodeSentState());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } on SocketException {
      emit(AuthErrorState("Network error. Please check your connection."));
    } on HandshakeException {
      emit(AuthErrorState("SSL/TLS handshake failed. Please try again."));
    } catch (e) {
      emit(AuthErrorState("Failed to send OTP: ${_getErrorMessage(e)}"));
    }
  }

  // Future<void> verifyOtp(String otp) async {
  //   emit(AuthLoadingState());
  //   try {
  //     if (_verificationId == null) {
  //       throw Exception(
  //           "Verification ID is null. Please retry the verification process.");
  //     }
  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId!,
  //       smsCode: otp,
  //     );
  //     await _firebaseAuth.signInWithCredential(credential);
  //     emit(AuthLoggedInState());
  //   } on SocketException {
  //     emit(AuthErrorState("Network error. Please check your connection."));
  //   } on HandshakeException {
  //     emit(AuthErrorState("SSL/TLS handshake failed. Please try again."));
  //   } catch (e) {
  //     emit(AuthErrorState("Failed to verify OTP: ${_getErrorMessage(e)}"));
  //   }
  // }

  Future<void> verifyOtp(
      {required String otp, required String phoneNumber}) async {
    emit(AuthLoadingState());
    try {
      if (_verificationId == null) {
        throw Exception(
            "Verification ID is null. Please retry the verification process.");
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);

      // After successful verification, retrieve user email based on phone number
      // Replace with actual phone number input by user
      UserModel? user = await getUserEmailWithPhone(phoneNumber);

      if (user != null) {
        // Store user's email for password reset
        String userEmail = user.email;

        // Navigate to password reset screen passing userEmail
        emit(
            AuthLoggedInState()); // or navigate to a screen where user can set new password
      } else {
        emit(AuthErrorState("User not found for the provided phone number."));
      }
    } on SocketException {
      emit(AuthErrorState("Network error. Please check your connection."));
    } on HandshakeException {
      emit(AuthErrorState("SSL/TLS handshake failed. Please try again."));
    } catch (e) {
      emit(AuthErrorState("Failed to verify OTP: ${_getErrorMessage(e)}"));
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+20' + phoneNumber;
    }
    return phoneNumber;
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The provided phone number is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Try again later.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'operation-not-allowed':
        return 'Phone number sign-in is not enabled. Please contact support.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      return _getFirebaseAuthErrorMessage(e);
    }
    return e.toString();
  }

  ///Create Account
  void createAccount({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    emit(CreateAccountLoadingState());
    _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      UserModel user = UserModel(
        name: name,
        phoneNumber: phoneNumber,
        uid: value.user?.uid ?? '',
        createdAt: DateTime.now().toString(),
        email: email,
      );
      emit(CreateAccountSuccessfullyState());
      saveUserAccountInformation(user);
    }).catchError((error) {
      emit(CreateAccountFailureState(error.toString()));
    });
  }

  void saveUserAccountInformation(UserModel user) {
    emit(SaveAccountInformationLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set(user.toJson())
        .then((value) {
      emit(SaveAccountInformationSuccessfullyState());
    }).catchError((error) {
      emit(SaveAccountInformationFailureState(error.toString()));
    });
  }

  ///Login With Email And Password

  void loginWithEmailAndPassword({required String email, required String password}) {
    emit(LoginLoadingState());
    _firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      emit(LoginSuccessfullyState());
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        emit(LoginFailureState(_getFirebaseAuthLoginErrorMessage(error)));
      } else {
        emit(LoginFailureState('An unknown error occurred.'));
      }
    });
  }

  String _getFirebaseAuthLoginErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'wrong-password':
        return 'The password is invalid or the user does not have a password.';
      case 'user-not-found':
        return 'There is no user corresponding to this email.';
      case 'user-disabled':
        return 'The user account has been disabled by an administrator.';
      case 'too-many-requests':
        return 'There have been too many attempts to sign in. Please try again later.';
      case 'operation-not-allowed':
        return 'Email and password accounts are not enabled. Please contact support.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }




  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(AuthLoggedOutState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  ///Reset Password
  Future<UserModel>? getUserEmailWithPhone(String phoneNumber) {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: phoneNumber)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        UserModel user = UserModel.fromJson(value.docs[0].data());
        return user;
      }
    }).catchError((error) {
      print(error.toString);
    });
    return null;
  }

  void updatePassword(String email, String newPassword) async {
    emit(UpdatePasswordLoadingState());
    await _firebaseAuth.currentUser!.updatePassword(newPassword).then((value) {
      emit(UpdatePasswordSuccessfullyState());
    }).catchError((error) {
      emit(AuthErrorState("Failed to update password: ${error.toString()}"));
    });
  }
}
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meta/meta.dart';
// import 'dart:io';
//
// part 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthStates> {
//   final FirebaseAuth _firebaseAuth;
//   String? _verificationId;
//
//   AuthCubit(this._firebaseAuth) : super(AuthInitialState());
//
//   // Register with email and password
//   Future<void> registerWithEmail(String name, String email, String password) async {
//     emit(CreateAccountLoadingState());
//     try {
//       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await userCredential.user!.updateDisplayName(name);
//       emit(CreateAccountSuccessfullyState());
//     } catch (e) {
//       emit(CreateAccountFailureState(_getErrorMessage(e)));
//     }
//   }
//
//   // Login with email and password
//   Future<void> loginWithEmail(String email, String password) async {
//     emit(AuthLoadingState());
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       emit(AuthLoggedInState());
//     } catch (e) {
//       emit(AuthErrorState(_getErrorMessage(e)));
//     }
//   }
//
//   // Reset password via phone OTP
//   Future<void> resetPasswordWithPhone(String phoneNumber) async {
//     emit(AuthLoadingState());
//     try {
//       final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);
//       await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: formattedPhoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           try {
//             await _firebaseAuth.signInWithCredential(credential);
//             emit(AuthLoggedInState());
//           } catch (e) {
//             emit(AuthErrorState(
//                 "Verification completed but login failed: ${_getErrorMessage(e)}"));
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           emit(AuthErrorState(_getFirebaseAuthErrorMessage(e)));
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           emit(AuthCodeSentState());
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } on SocketException {
//       emit(AuthErrorState("Network error. Please check your connection."));
//     } on HandshakeException {
//       emit(AuthErrorState("SSL/TLS handshake failed. Please try again."));
//     } catch (e) {
//       emit(AuthErrorState("Failed to send OTP: ${_getErrorMessage(e)}"));
//     }
//   }
//
//   // Verify OTP and reset password
//   Future<void> verifyOtpAndResetPassword(String otp, String newPassword) async {
//     emit(AuthLoadingState());
//     try {
//       if (_verificationId == null) {
//         throw Exception("Verification ID is null. Please retry the verification process.");
//       }
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otp,
//       );
//       await _firebaseAuth.signInWithCredential(credential);
//       User? user = _firebaseAuth.currentUser;
//       if (user != null) {
//         await user.updatePassword(newPassword);
//         emit(AuthLoggedInState());
//       } else {
//         emit(AuthErrorState("User not found"));
//       }
//     } on SocketException {
//       emit(AuthErrorState("Network error. Please check your connection."));
//     } on HandshakeException {
//       emit(AuthErrorState("SSL/TLS handshake failed. Please try again."));
//     } catch (e) {
//       emit(AuthErrorState("Failed to verify OTP and reset password: ${_getErrorMessage(e)}"));
//     }
//   }
//
//   String _formatPhoneNumber(String phoneNumber) {
//     if (!phoneNumber.startsWith('+')) {
//       phoneNumber = '+20' + phoneNumber;
//     }
//     return phoneNumber;
//   }
//
//   String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'invalid-phone-number':
//         return 'The provided phone number is not valid.';
//       case 'too-many-requests':
//         return 'Too many requests. Try again later.';
//       case 'network-request-failed':
//         return 'Network error. Please check your connection.';
//       case 'quota-exceeded':
//         return 'SMS quota exceeded. Try again later.';
//       case 'user-disabled':
//         return 'This user account has been disabled.';
//       case 'operation-not-allowed':
//         return 'Phone number sign-in is not enabled. Please contact support.';
//       default:
//         return e.message ?? 'An unknown error occurred.';
//     }
//   }
//
//   String _getErrorMessage(dynamic e) {
//     if (e is FirebaseAuthException) {
//       return _getFirebaseAuthErrorMessage(e);
//     }
//     return e.toString();
//   }
// }
//
