
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'dart:io';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  final FirebaseAuth _firebaseAuth;
  String? _verificationId;

  AuthCubit(this._firebaseAuth) : super(AuthInitialState());

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

  Future<void> verifyOtp(String otp) async {
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
      emit(AuthLoggedInState());
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

  void createAccount({
    required String userName,
    required String password,
    required String phoneNumber,
  }) async {
    emit(CreateAccountLoadingState());

    try {
      // Check if user is already authenticated with phone number
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String email = '$phoneNumber@dummy.com';
        await user.updateEmail(email);
        await user.updatePassword(password);
        await user.updateProfile(displayName: userName);
        emit(CreateAccountSuccessfullyState());
      } else {
        emit(CreateAccountFailureState('User not authenticated'));
      }
    } catch (e) {
      emit(CreateAccountFailureState(_getErrorMessage(e)));
    }
  }
}
