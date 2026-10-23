import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(0, tabIndex: 0)) {
    on<SetIndex>(_setIndex);
    on<SetNavBarButton>(_setNavBarButton);
    on<SetTabIndex>(_setTabIndex);
  }

  Future<void> _setIndex(SetIndex event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        selectedIndex: event.index,
      ),
    );
  }

  Future<void> _setNavBarButton(
      SetNavBarButton event, Emitter<HomeState> emit) async {
    List<Widget> list = List.from(state.navButtonList);
    switch (state.selectedIndex) {
      case 0:
        list[0] = event.navBarButton;
        break;
      case 1:
        list[1] = event.navBarButton;
        break;
      case 3:
        list[3] = event.navBarButton;
        break;
      default:
        break;
    }
    emit(
      state.copyWith(
        navButtonList: list,
      ),
    );
  }

  Future<void> _setTabIndex(SetTabIndex event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        tabIndex: event.tabIndex,
      ),
    );
  }
}
