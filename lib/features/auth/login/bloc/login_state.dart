import 'package:finoco/core/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Loading extends LoginState {}

class SubmitLogin extends LoginState {}

class SubmitLoginSuccess extends LoginState {}

class StoreUser extends LoginState {
  final String accessToken;
  final String sub;
  const StoreUser(this.accessToken, this.sub);

  @override
  String toString() {
    return "StoreUser(accessToken: $accessToken)";
  }
}

class UserNotConfirmed extends LoginState {
  final User user;

  const UserNotConfirmed(this.user);
}

class ForceChangePassword extends LoginState {}

class Failure extends LoginState {
  final int failureCode;
  final String userId;
  final DateTime blockedUntil;
  const Failure(
      {@required this.failureCode, @required this.userId, this.blockedUntil});

  @override
  List<Object> get props => [failureCode, userId];

  @override
  String toString() => 'Failure { failureCode: $failureCode, userId: $userId }';
}
