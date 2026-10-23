// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends LoginEvent {
  final String username;
  final String password;
  const Submitted(this.username, this.password);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Submitted';
  }
}

class ConfirmSignIn extends LoginEvent {
  final String? newPassword;
  final String? email;
  const ConfirmSignIn({
    this.email,
    this.newPassword,
  });
}

class GoogleSignIn extends LoginEvent {}

class AppleSignIn extends LoginEvent {}

class FacebookSignIn extends LoginEvent {}

class SignOut extends LoginEvent {}
