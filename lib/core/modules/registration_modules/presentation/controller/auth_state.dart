part of 'auth_cubit.dart';

@immutable
abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class ChangeLoginPasswordIconState extends AuthStates {}
class ChangeRegisterPasswordIconState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthCodeSentState extends AuthStates {}

class AuthLoggedInState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String message;

  AuthErrorState(this.message);
}

class CreateAccountLoadingState extends AuthStates {}

class CreateAccountSuccessfullyState extends AuthStates {}

class CreateAccountFailureState extends AuthStates {
  final String errorMessage;

  CreateAccountFailureState(this.errorMessage);
}

//Save User Information

class SaveAccountInformationLoadingState extends AuthStates {}

class SaveAccountInformationSuccessfullyState extends AuthStates {}

class SaveAccountInformationFailureState extends AuthStates {
  final String errorMessage;

  SaveAccountInformationFailureState(this.errorMessage);
}
class AuthLoggedOutState extends AuthStates {}


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
