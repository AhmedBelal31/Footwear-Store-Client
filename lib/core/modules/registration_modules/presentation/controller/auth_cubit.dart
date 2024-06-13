import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

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
          await _firebaseAuth.signInWithCredential(credential);
          emit(AuthLoggedInState());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthErrorState(e.message ?? "An error occurred"));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(AuthCodeSentState());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(AuthLoadingState());
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      emit(AuthLoggedInState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+20' + phoneNumber;
    }
    return phoneNumber;
  }
}
