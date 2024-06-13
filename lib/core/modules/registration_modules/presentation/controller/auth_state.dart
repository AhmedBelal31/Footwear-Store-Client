part of 'auth_cubit.dart';

@immutable
abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthCodeSentState extends AuthStates {}

class AuthLoggedInState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String message;
  AuthErrorState(this.message);
}
