import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './register_event.dart';
import './register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.empty());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        event.registrationType,
        event.email,
        event.password,
      );
    }
    // else if (event is SubmitVisitor) {
    //   yield* _mapSubmitVisitorToState();
    // }
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String registrationType,
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      yield RegisterState.success(user);
    } catch (e) {
      yield RegisterState.failure(409);
    }
  }
}

// Stream<RegisterState> _mapSubmitVisitorToState() async* {
//   yield RegisterState.loading();
//   try {
//     yield RegisterState.success("userName");
//   } catch (e) {
//     print(e);
//     yield RegisterState.failure(500);
//   }
// }
