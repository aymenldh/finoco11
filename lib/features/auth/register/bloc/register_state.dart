import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class RegisterState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final int failureCode;
  final UserCredential? user;
  final bool? guestLoggedIn;

  RegisterState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.failureCode,
    this.guestLoggedIn,
    this.user,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureCode: 0,
      guestLoggedIn: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        failureCode: 0,
        guestLoggedIn: false);
  }

  factory RegisterState.failure(int code) {
    return RegisterState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureCode: code,
      guestLoggedIn: false,
    );
  }

  factory RegisterState.success(UserCredential user) {
    return RegisterState(
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        failureCode: 0,
        user: user,
        guestLoggedIn: true);
  }

  RegisterState update() {
    return copyWith(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureCode: failureCode ?? this.failureCode,
    );
  }

  @override
  String toString() {
    return '''RegisterState {    
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureCode: $failureCode,
    }''';
  }
}
