import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finoco/core/models/user.dart';
import 'package:finoco/core/repository/local_storage.dart';
import 'package:flutter/foundation.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is NotActivated) {
      yield* _mapNotActivatedToState(event);
    } else if (event is AppOnBoardingFinished) {
      yield* _mapAppOnBoardingFinishedToState();
    } else if (event is SessionExpired) {
      yield* _mapAppSessionExpired();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      yield AuthenticationUninitialized();
    } catch (e) {
      print(e);
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(LoggedIn event) async* {
    yield AuthenticationAuthenticated();
  }

  Stream<AuthenticationState> _mapNotActivatedToState(
      NotActivated event) async* {
    yield AuthenticationNotActivated(user: event.user);
  }

  Stream<AuthenticationState> _mapAppOnBoardingFinishedToState() async* {
    yield FinishOnBoarding();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticationUnauthenticated();
  }

  Stream<AuthenticationState> _mapAppSessionExpired() async* {
    yield ExpiredSession();
  }
}
