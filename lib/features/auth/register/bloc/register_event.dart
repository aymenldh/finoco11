import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends RegisterEvent {
  final String registrationType;
  final String email;
  final String password;

  const Submitted({
    required this.registrationType,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [registrationType, email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, registrationType: $registrationType, password: $password,}';
  }
}

class SubmitVisitor extends RegisterEvent {}
