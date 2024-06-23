// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:footwear_store_client/core/modules/registration_modules/data/models/user_model.dart';
// import 'dart:io';
//
// part 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthStates> {
//
//
//   AuthCubit() : super(AuthInitialState());
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//   String? myVerificationId;
//   String? emailLinkedWithPhoneNumber;
//
//   ///Change Password Icon
//   IconData loginPasswordIcon = Icons.visibility;
//   bool isLoginPasswordShown = true;
//
//
//   void changeLoginPasswordIcon() {
//     isLoginPasswordShown
//         ? loginPasswordIcon = Icons.visibility_off
//         : loginPasswordIcon = Icons.visibility;
//     isLoginPasswordShown = !isLoginPasswordShown;
//     emit(ChangeLoginPasswordIconState());
//   }
//
//   IconData registerPasswordIcon = Icons.visibility;
//   bool isRegisterPasswordShown = true;
//
//   void changeRegisterPasswordIcon() {
//     isRegisterPasswordShown
//         ? registerPasswordIcon = Icons.visibility_off
//         : registerPasswordIcon = Icons.visibility;
//     isRegisterPasswordShown = !isRegisterPasswordShown;
//     emit(ChangeRegisterPasswordIconState());
//   }
//
//
//   IconData resetPasswordIcon = Icons.visibility;
//   bool isResetPasswordShown = true;
//
//   void changeResetPasswordIcon() {
//     isResetPasswordShown
//         ? resetPasswordIcon = Icons.visibility_off
//         : resetPasswordIcon = Icons.visibility;
//     isResetPasswordShown = !isResetPasswordShown;
//     emit(ChangeResetPasswordIconState());
//   }
//
//   // ///Verify Phone Number
//   Future<void> registerWithPhoneNumber(String phoneNumber) async {
//     emit(RegisterWithPhoneNumberLoadingState());
//     try {
//       final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);
//
//     await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: formattedPhoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           try {
//
//             print('Phone number linked successfully!');
//             await _firebaseAuth.signInWithCredential(credential);
//             emit(VerificationCompletedSuccessState());
//           } catch (e) {
//             emit(RegisterWithPhoneNumberFailureState(
//                 "Verification completed but login failed: ${_getErrorMessage(
//                     e)}"));
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           emit(RegisterWithPhoneNumberFailureState(
//               _getFirebaseAuthErrorMessage(e)));
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           myVerificationId = verificationId;
//           print('_verificationId is ${myVerificationId}');
//           emit(CodeSentSuccessState());
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           myVerificationId = verificationId;
//         },
//       );
//     } on SocketException {
//       emit(RegisterWithPhoneNumberFailureState(
//           "Network error. Please check your connection."));
//     } on HandshakeException {
//       emit(RegisterWithPhoneNumberFailureState(
//           "SSL/TLS handshake failed. Please try again."));
//     } catch (e) {
//       emit(RegisterWithPhoneNumberFailureState(
//           "Failed to send OTP: ${_getErrorMessage(e)}"));
//     }
//   }
//
//
//   Future<void> verifyOtp(
//       {required String otp, required String phoneNumber}) async {
//     emit(VerifyOtpLoadingState());
//     try {
//       if (myVerificationId == null) {
//         throw Exception(
//             "Verification ID is null. Please retry the verification process.");
//       }
//       final credential = PhoneAuthProvider.credential(
//         verificationId: myVerificationId!,
//         smsCode: otp,
//       );
//       await _firebaseAuth.signInWithCredential(credential);
//
//
//       String formattedPhoneNumber = phoneNumber.substring(2);
//       UserModel? user = await getUserEmailWithPhone(formattedPhoneNumber);
//
//       if (user != null) {
//
//         // Store user's email for password reset
//         String userEmail = user.email;
//         emailLinkedWithPhoneNumber = user.email;
//         // Emit state to indicate successful OTP verification and user found
//         emit(FoundRelatedEmailForPhoneState(userEmail));
//       } else {
//         emit(VerifyOtpFailureState(
//             "User not found for the provided phone number."));
//       }
//       emit(VerifyOtpSuccessState());
//     } on SocketException {
//       emit(VerifyOtpFailureState(
//           "Network error. Please check your connection."));
//     } on HandshakeException {
//       emit(
//           VerifyOtpFailureState("SSL/TLS handshake failed. Please try again."));
//     } catch (e) {
//       print(e.toString());
//       emit(VerifyOtpFailureState(
//           "Failed to verify OTP: ${_getErrorMessage(e)}"));
//     }
//   }
//
//   Future<void> sendPasswordResetEmail(String email) async {
//     emit (ResetPasswordViaEmailLoadingState());
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//       emit(ResetPasswordViaEmailSuccessState());
//     } on FirebaseException catch (error) {
//       emit(ResetPasswordViaEmailFailureState(
//           "Failed to send password reset email: ${error.message}"));
//     } catch (e) {
//       print(e.toString());
//       emit(ResetPasswordViaEmailFailureState(
//           "Failed to send password reset email: ${e.toString()}"));
//     }
//   }
//
//
//
//
//
//
//   Future<UserModel?> getUserEmailWithPhone(String phoneNumber) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('phoneNumber', isEqualTo: phoneNumber)
//           .get();
//       print('The Data Of User IS ${querySnapshot.docs.first.data()}');
//       if (querySnapshot.docs.isNotEmpty) {
//         return UserModel.fromJson(querySnapshot.docs.first.data());
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }
//
//   ///Reset Password
//
//   void updatePassword(String newPassword) async {
//     emit(UpdatePasswordLoadingState());
//     await _firebaseAuth.currentUser!.updatePassword(newPassword).then((value) {
//       print(_firebaseAuth.currentUser!.email);
//       print(_firebaseAuth.currentUser!.phoneNumber);
//
//       emit(UpdatePasswordSuccessfullyState());
//     }).catchError((error) {
//       emit(UpdatePasswordFailureState(
//           "Failed to update password: ${error.toString()}"));
//     });
//   }
//
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
//
//   ///Create Account
//   void createAccount({
//     required String email,
//     required String password,
//     required String name,
//     required String phoneNumber,
//   }) async {
//     emit(CreateAccountLoadingState());
//     _firebaseAuth
//         .createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     )
//         .then((value) {
//       UserModel user = UserModel(
//         name: name,
//         phoneNumber: phoneNumber,
//         uid: value.user!.uid,
//         createdAt: DateTime.now().toString(),
//         email: email,
//       );
//       emit(CreateAccountSuccessfullyState());
//       saveUserAccountInformation(user);
//     }).catchError((error) {
//       // if(error is FirebaseAuthException) {
//       //   if(error.code == 'email-already-in-use')
//       //     {
//       //       emit(CreateAccountFailureState("Email is already in use by another account."));
//       //     }
//       // }
//       emit(CreateAccountFailureState(error.toString()));
//     });
//   }
//
//   void saveUserAccountInformation(UserModel user) {
//     emit(SaveAccountInformationLoadingState());
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc()
//         .set(user.toJson())
//         .then((value) {
//       emit(SaveAccountInformationSuccessfullyState());
//     }).catchError((error) {
//       emit(SaveAccountInformationFailureState(error.toString()));
//     });
//   }
//
//
//   Future<void> validatePhoneNumber(String phoneNumber) async {
//     emit(ValidatePhoneNumberLoadingState());
//
//     try {
//       final bool exists = await checkIfPhoneNumberExists(phoneNumber);
//       if (exists) {
//         emit(PhoneNumberExistState());
//       } else {
//         emit(PhoneNumberNotExistState());
//       }
//     } catch (e) {
//       emit(ValidatePhoneNumberFailureState('Error: ${e.toString()}'));
//     }
//   }
//
//   Future<bool> checkIfPhoneNumberExists(String phoneNumber) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('phoneNumber', isEqualTo: phoneNumber)
//           .get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking phone number: ${e.toString()}');
//       throw Exception('Failed to check phone number');
//     }
//   }
//
//   ///Login With Email And Password
//
//   void loginWithEmailAndPassword(
//       {required String email, required String password}) {
//     emit(LoginLoadingState());
//     _firebaseAuth
//         .signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     ).then((value) {
//       emit(LoginSuccessfullyState());
//     }).catchError((error) {
//       if (error is FirebaseAuthException) {
//         emit(LoginFailureState(_getFirebaseAuthLoginErrorMessage(error)));
//       } else {
//         emit(LoginFailureState('An unknown error occurred.'));
//       }
//     });
//   }
//
//   String _getFirebaseAuthLoginErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'invalid-email':
//         return 'The email address is badly formatted.';
//       case 'wrong-password':
//         return 'The password is invalid or the user does not have a password.';
//       case 'user-not-found':
//         return 'There is no user corresponding to this email.';
//       case 'user-disabled':
//         return 'The user account has been disabled by an administrator.';
//       case 'too-many-requests':
//         return 'There have been too many attempts to sign in. Please try again later.';
//       case 'operation-not-allowed':
//         return 'Email and password accounts are not enabled. Please contact support.';
//       default:
//         return e.message ?? 'An unknown error occurred.';
//     }
//   }
//
//
//   /// Sign out
//   Future<void> signOut() async {
//     try {
//       await _firebaseAuth.signOut();
//       emit(AuthLoggedOutState());
//     } catch (e) {
//       emit(RegisterWithPhoneNumberFailureState(e.toString()));
//     }
//   }
//
//
//   bool isEmailVerified() {
//     return _firebaseAuth.currentUser!.emailVerified;
//   }
//
//   bool isEmailSent = false;
//
//   void sendEmailVerification() {
//     emit(SendEmailVerificationLoadingState());
//     _firebaseAuth.currentUser!.sendEmailVerification().then((value) {
//       emit(SendEmailVerificationSuccessfullyState());
//     }).catchError((error) {
//       print(error.toString());
//       emit(RegisterWithPhoneNumberFailureState(
//           "Failed to send email verification: ${error.toString()}"));
//     });
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footwear_store_client/core/modules/registration_modules/data/models/user_model.dart';
import 'dart:io';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? myVerificationId;
  String? emailLinkedWithPhoneNumber;

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

  IconData resetPasswordIcon = Icons.visibility;
  bool isResetPasswordShown = true;

  void changeResetPasswordIcon() {
    isResetPasswordShown
        ? resetPasswordIcon = Icons.visibility_off
        : resetPasswordIcon = Icons.visibility;
    isResetPasswordShown = !isResetPasswordShown;
    emit(ChangeResetPasswordIconState());
  }

  // ///Verify Phone Number
  Future<void> registerWithPhoneNumber(String phoneNumber) async {
    emit(RegisterWithPhoneNumberLoadingState());
    try {
      final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
            emit(VerificationCompletedSuccessState());
          } catch (e) {
            emit(RegisterWithPhoneNumberFailureState(
                "Verification completed but login failed: ${_getErrorMessage(e)}"));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(RegisterWithPhoneNumberFailureState(
              _getFirebaseAuthErrorMessage(e)));
        },
        codeSent: (String verificationId, int? resendToken) {
          myVerificationId = verificationId;
          print('_verificationId is ${myVerificationId}');
          emit(CodeSentSuccessState());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          myVerificationId = verificationId;
        },
      );
    } catch (e) {
      emit(RegisterWithPhoneNumberFailureState(
          "Failed to send OTP: ${_getErrorMessage(e)}"));
    }
  }

  Future<void> verifyOtp(
      {required String otp, required String phoneNumber}) async {
    emit(VerifyOtpLoadingState());
    try {
      if (myVerificationId == null) {
        throw Exception(
            "Verification ID is null. Please retry the verification process.");
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: myVerificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      emit(VerifyOtpSuccessState());
    } catch (e) {
      print(e.toString());
      emit(VerifyOtpFailureState(
          "Failed to verify OTP: ${_getErrorMessage(e)}"));
    }
  }

  void sendPasswordResetEmail(String email) {
    emit(ResetPasswordViaEmailLoadingState());

    bool userFound = false;

    for (int i = 0; i < allUsers.length; i++) {
      print(allUsers[i].email);
      if (email == allUsers[i].email) {
        userFound = true;
        _firebaseAuth.sendPasswordResetEmail(email: email).then((_) {
          emit(ResetPasswordViaEmailSuccessState());
        }).catchError((error) {
          emit(ResetPasswordViaEmailFailureState(
              "Failed to send password reset email: ${error.toString()}"));
        });
        break; // exit the loop once the email is found and reset email is sent
      }
    }

    if (!userFound) {
      emit(UserNotFoundState());
    }
  }


  // List<String> usersEmail = [];
  //
  // void getUsersEmailFromFirestore() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((value) {
  //         for (int i = 0; i < value.docs.length; i++) {
  //           usersEmail.add(value.docs[i].data()['email']);
  //           print(value.docs[i].data()['email']);
  //         }
  //
  //       }).catchError((error) {
  //         print(error.toString());
  //
  //   });
  // }

  ///Reset Password

  void updatePassword(String newPassword) async {
    emit(UpdatePasswordLoadingState());

    await _firebaseAuth.currentUser!.updatePassword(newPassword).then((value) {
      print(_firebaseAuth.currentUser!.email);
      print(_firebaseAuth.currentUser!.phoneNumber);

      emit(UpdatePasswordSuccessfullyState());
    }).catchError((error) {
      emit(UpdatePasswordFailureState(
          "Failed to update password: ${error.toString()}"));
    });
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

    if (await checkIfPhoneNumberExists(phoneNumber) == false) {
      _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        UserModel user = UserModel(
          name: name,
          phoneNumber: phoneNumber,
          uid: value.user!.uid,
          createdAt: DateTime.now().toString(),
          email: email,
        );
        emit(CreateAccountSuccessfullyState());
        saveUserAccountInformation(user);
      }).catchError((error) {
        emit(CreateAccountFailureState(_getFirebaseAuthErrorMessage(error)));
      });
    } else {
      emit(PhoneNumberExistState());
    }
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

  List<UserModel> allUsers = [];

  void fetchAllUsers() {
    emit(FetchAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((values) {
      allUsers.clear();
      for (var element in values.docs) {
        allUsers.add(UserModel.fromJson(element.data()));
      }
      emit(FetchAllUsersSuccessState());
    }).catchError((error) {
      emit(FetchAllUsersFailureState(error.toString()));
    });
  }

  // Future<void> validatePhoneNumber(String phoneNumber) async {
  //   emit(ValidatePhoneNumberLoadingState());
  //
  //   try {
  //     final bool exists = await checkIfPhoneNumberExists(phoneNumber);
  //     if (exists) {
  //       emit(PhoneNumberExistState());
  //     } else {
  //       emit(PhoneNumberNotExistState());
  //     }
  //   } catch (e) {
  //     emit(ValidatePhoneNumberFailureState('Error: ${e.toString()}'));
  //   }
  // }

  Future<bool> checkIfPhoneNumberExists(String phoneNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: ${e.toString()}');
      throw Exception('Failed to check phone number');
    }
  }

  ///Login With Email And Password

  void loginWithEmailAndPassword(
      {required String email, required String password}) {
    emit(LoginLoadingState());
    _firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
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
      emit(RegisterWithPhoneNumberFailureState(e.toString()));
    }
  }

  bool isEmailVerified() {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  bool isEmailSent = false;

  void sendEmailVerification() {
    emit(SendEmailVerificationLoadingState());
    _firebaseAuth.currentUser!.sendEmailVerification().then((value) {
      emit(SendEmailVerificationSuccessfullyState());
    }).catchError((error) {
      print(error.toString());
      emit(RegisterWithPhoneNumberFailureState(
          "Failed to send email verification: ${error.toString()}"));
    });
  }
}
