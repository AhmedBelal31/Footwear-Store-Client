part of 'auth_cubit.dart';

@immutable
abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class ChangeLoginPasswordIconState extends AuthStates {}
class ChangeRegisterPasswordIconState extends AuthStates {}
class ChangeResetPasswordIconState extends AuthStates {}



/// Register With PhoneNumber States
class RegisterWithPhoneNumberLoadingState extends AuthStates {}
class RegisterWithPhoneNumberFailureState extends AuthStates {
  final String message;

  RegisterWithPhoneNumberFailureState(this.message);
}

///Verification Completed State
class VerificationCompletedSuccessState extends AuthStates {}

///CodeSent
class CodeSentSuccessState extends AuthStates {}

///Verify OTP States
class VerifyOtpLoadingState extends AuthStates {}
class VerifyOtpSuccessState extends AuthStates {}
class VerifyOtpFailureState extends AuthStates {
  final String message;

  VerifyOtpFailureState(this.message);
}

class CreateAccountLoadingState extends AuthStates {}

class CreateAccountSuccessfullyState extends AuthStates {}

class CreateAccountFailureState extends AuthStates {
  final String errorMessage;

  CreateAccountFailureState(this.errorMessage);
}

///Save User Information

class SaveAccountInformationLoadingState extends AuthStates {}

class SaveAccountInformationSuccessfullyState extends AuthStates {}

class SaveAccountInformationFailureState extends AuthStates {
  final String errorMessage;

  SaveAccountInformationFailureState(this.errorMessage);
}
class AuthLoggedOutState extends AuthStates {}
class AuthLoggedOutFailureState extends AuthStates {
  final String errorMessage;

  AuthLoggedOutFailureState(this.errorMessage);
}


///Login To Account

class LoginLoadingState extends AuthStates {}

class LoginSuccessfullyState extends AuthStates {}

class LoginFailureState extends AuthStates {
  final String errorMessage;

  LoginFailureState(this.errorMessage);
}


///Update User Password

class UpdatePasswordLoadingState extends AuthStates {}

class UpdatePasswordSuccessfullyState extends AuthStates {}

class UpdatePasswordFailureState extends AuthStates {
  final String errorMessage;

  UpdatePasswordFailureState(this.errorMessage);
}

///Send Email Verification


class SendEmailVerificationLoadingState extends AuthStates {}


class SendEmailVerificationSuccessfullyState extends AuthStates {}


class FoundRelatedEmailForPhoneState extends AuthStates {
  final String email;
  FoundRelatedEmailForPhoneState(this.email);
}


///Validate Phone Number

class ValidatePhoneNumberLoadingState extends AuthStates {}
class PhoneNumberExistState extends AuthStates {}
class PhoneNumberNotExistState extends AuthStates {}
class ValidatePhoneNumberFailureState extends AuthStates {
  final String message;

  ValidatePhoneNumberFailureState(this.message);
}


///Reset Password via Email


class ResetPasswordViaEmailLoadingState extends AuthStates {}
class ResetPasswordViaEmailSuccessState extends AuthStates {}
class ResetPasswordViaEmailFailureState extends AuthStates {
  final String message;

  ResetPasswordViaEmailFailureState(this.message);
}


