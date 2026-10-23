import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './login_event.dart';
import './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Submitted) {
      yield* _mapFormSubmittedToState(event);
    }
    if (event is ConfirmSignIn) {
      yield* _mapConfirmSignInToState(event);
    }
    if (event is GoogleSignIn) {
      yield* _mapGoogleSignInToState(event);
    }
    if (event is FacebookSignIn) {
      yield* _mapFacebookSignInToState(event);
    }
    if (event is AppleSignIn) {
      yield* _mapAppleSignInToState(event);
    }
    if (event is SignOut) {
      yield* _mapSignOutToState();
    }
  }

  Stream<LoginState> _mapFormSubmittedToState(Submitted event) async* {
    yield SubmitLogin();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.username, password: event.password);

      yield const StoreUser('', '');
    } catch (e) {
      yield const Failure(
        failureCode: 409,
        userId: "-1",
      );
    }
  }

  Stream<LoginState> _mapConfirmSignInToState(ConfirmSignIn event) async* {
    try {
      yield Loading();

      yield const StoreUser('accessToken', 'userSub');
    } catch (e) {
      log(e.toString());
      yield const Failure(failureCode: 409, userId: "-1");
    }
  }

  Stream<LoginState> _mapGoogleSignInToState(GoogleSignIn event) async* {
    yield SubmitLogin();
    try {
      // await LocalStorage.getInstance().setAccessToken("accessToken");
      yield const StoreUser("accessToken", "userSub");
    } catch (e) {
      yield const Failure(failureCode: 409, userId: "-1");
    }
  }

  Stream<LoginState> _mapFacebookSignInToState(FacebookSignIn event) async* {
    yield SubmitLogin();
    try {
      // await LocalStorage.getInstance().setAccessToken('accessToken');
      yield const StoreUser("accessToken", 'userSub');
    } catch (e) {
      yield const Failure(failureCode: 409, userId: "-1");
    }
  }

  Stream<LoginState> _mapAppleSignInToState(AppleSignIn event) async* {
    yield SubmitLogin();
    try {
      // await LocalStorage.getInstance().setAccessToken('accessToken');
      yield const StoreUser("accessToken", 'res');
    } catch (e) {
      yield const Failure(failureCode: 409, userId: "-1");
    }
  }

  Stream<LoginState> _mapSignOutToState() async* {
    yield Loading();
    await FirebaseAuth.instance.signOut();
    yield LoginInitial();
  }
}
