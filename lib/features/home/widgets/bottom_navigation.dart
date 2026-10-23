import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/colors.dart';
import '../bloc/home_bloc.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(SetIndex(0));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, -4),
              blurRadius: 15,
              spreadRadius: 0,
              color: const Color(0xffCDCDCD).withOpacity(.4)),
        ],
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.navButtonList[state.selectedIndex] != null)
                state.navButtonList[state.selectedIndex],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectTab(0, context);
                        },
                        icon: Icon(
                          Icons.dashboard_outlined,
                          size: 32,
                          color: state.selectedIndex == 0
                              ? AppColor.appPrimaryColor
                              : null,
                        ),
                      ),
                      Text(
                        'Accueil',
                        style: TextStyle(
                            color: state.selectedIndex == 0
                                ? AppColor.appPrimaryColor
                                : const Color(0xff818181),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectTab(1, context);
                        },
                        icon: Icon(
                          Icons.groups_outlined,
                          size: 32,
                          color: state.selectedIndex == 1
                              ? AppColor.appPrimaryColor
                              : null,
                        ),
                      ),
                      Text(
                        'Clients',
                        style: TextStyle(
                            color: state.selectedIndex == 1
                                ? AppColor.appPrimaryColor
                                : const Color(0xff818181),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectTab(2, context);
                        },
                        icon: Icon(
                          Icons.sync,
                          size: 32,
                          color: state.selectedIndex == 2
                              ? AppColor.appPrimaryColor
                              : null,
                        ),
                      ),
                      Text(
                        'Synchronisation',
                        style: TextStyle(
                            color: state.selectedIndex == 2
                                ? AppColor.appPrimaryColor
                                : const Color(0xff818181),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectTab(3, context);
                        },
                        icon: Icon(
                          Icons.more_vert_outlined,
                          size: 32,
                          color: state.selectedIndex == 3
                              ? AppColor.appPrimaryColor
                              : null,
                        ),
                      ),
                      Text(
                        'Plus',
                        style: TextStyle(
                            color: state.selectedIndex == 3
                                ? AppColor.appPrimaryColor
                                : const Color(0xff818181),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectTab(int index, BuildContext context) {
    context.read<HomeBloc>().add(SetIndex(index));
  }
}
