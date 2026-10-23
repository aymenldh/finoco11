part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationUninitialized extends AuthenticationState {}

class StartOnBoarding extends AuthenticationState {}

class FinishOnBoarding extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationNotActivated extends AuthenticationState {
  final User user;

  AuthenticationNotActivated({this.user});
}

class AdvisorStatusReceived extends AuthenticationState {}

class ExpiredSession extends AuthenticationState {}
