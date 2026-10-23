import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:flutter/material.dart';

class ScaffoldHeader extends StatefulWidget {
  final String title;
  final Widget child;
  final Key scaffoldKey;
  final bool showBackButton;
  final Function customBackButtonCallBack;
  final Widget navBarButton;
  final Widget bottomNavbar;
  final Widget bottomAppbar;
  final Widget titleLineWidget;
  final int screen;
  final Color backgroundColor;
  final int index;
  final bool isNotLogged;

  const ScaffoldHeader({
    Key key,
    this.index,
    this.title,
    this.child,
    this.scaffoldKey,
    this.navBarButton,
    this.bottomAppbar,
    this.showBackButton = true,
    this.customBackButtonCallBack,
    this.titleLineWidget,
    this.screen,
    this.backgroundColor,
    this.bottomNavbar,
    this.isNotLogged,
  }) : super(key: key);

  @override
  State<ScaffoldHeader> createState() => _ScaffoldHeaderState();
}

class _ScaffoldHeaderState extends State<ScaffoldHeader> {
  static int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screen != null) {
      _selectedIndex = widget.screen;
    }
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? AppColor.appTertiaryBackground,
      key: widget.scaffoldKey,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              boxShadow: widget.bottomAppbar != null
                  ? [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 15,
                          spreadRadius: 0,
                          color: const Color(0xffCDCDCD).withOpacity(.4)),
                    ]
                  : null,
              color: widget.backgroundColor ??
                  (widget.bottomAppbar != null
                      ? AppColor.appSecondaryBackground
                      : AppColor.appTertiaryBackground),
              borderRadius: widget.bottomAppbar != null
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: widget.titleLineWidget == null
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColor.appSecondaryColor,
                        ),
                        onPressed: widget.customBackButtonCallBack ??
                            () {
                              Navigator.of(context).pop();
                            },
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(widget.bottomAppbar == null ||
                                !widget.showBackButton
                            ? 10.0
                            : 0),
                        child: SelectableText(
                          widget.title,
                          style: AppThemes.appBarTitleTextStyle,
                        ),
                      ),
                    ),
                    if (widget.titleLineWidget != null) widget.titleLineWidget,
                  ],
                ),
                if (widget.bottomAppbar != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: widget.bottomAppbar,
                  ),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: widget.bottomNavbar != null
          ? Container(
              height: 100,
              child: widget.bottomNavbar,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, -2),
                      blurRadius: 5,
                      spreadRadius: 0,
                      color: const Color(0xffCDCDCD).withOpacity(.4)),
                ],
              ),
            )
          : null,
    );
  }
}
