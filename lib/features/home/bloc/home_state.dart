// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final int tabIndex;
  final List<Widget> navButtonList;

  const HomeState(this.selectedIndex,
      {this.tabIndex, this.navButtonList = const [null, null, null, null]});

  @override
  List<Object> get props => [selectedIndex, tabIndex, navButtonList];

  @override
  bool get stringify => true;

  HomeState copyWith(
      {int selectedIndex,
      int tabIndex,
      Widget navBarButton,
      List<Widget> navButtonList}) {
    return HomeState(
      selectedIndex ?? this.selectedIndex,
      tabIndex: tabIndex ?? this.tabIndex,
      navButtonList: navButtonList ?? this.navButtonList,
    );
  }
}
