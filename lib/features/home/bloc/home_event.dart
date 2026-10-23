// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetIndex extends HomeEvent {
  final int index;

  SetIndex(this.index);
  @override
  List<Object> get props => [index];

  @override
  String toString() => 'SetIndex(index: $index)';
}

class SetNavBarButton extends HomeEvent {
  final Widget navBarButton;

  SetNavBarButton(this.navBarButton);
}

class SetTabIndex extends HomeEvent {
  final int tabIndex;

  SetTabIndex(this.tabIndex);
  @override
  List<Object> get props => [tabIndex];

  @override
  String toString() => 'SetTabIndex(tabIndex: $tabIndex)';
}
