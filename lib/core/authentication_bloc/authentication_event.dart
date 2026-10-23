part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class AppOnBoardingFinished extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String? accessToken;
  final String sub;
  LoggedIn(this.sub, {this.accessToken});

  @override
  String toString() {
    return 'LoggedIn(accessToken : $accessToken)';
  }
}

class LoggedOut extends AuthenticationEvent {}

class SessionExpired extends AuthenticationEvent {}

class NotActivated extends AuthenticationEvent {
  final User user;
  NotActivated(this.user);
}
