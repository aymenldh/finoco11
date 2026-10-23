import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/core/authentication_bloc/authentication_bloc.dart';
import 'package:finoco/core/repository/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'config/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _conf() async {
    bool? isAutoConnect = await LocalStorage.getInstance().getSaveLogin();
    if (isAutoConnect != null && isAutoConnect) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid != null) {
        context.read<AuthenticationBloc>().add(LoggedIn('sub'));
      } else {
        context.read<AuthenticationBloc>().add(LoggedOut());
      }
    } else {
      await FirebaseAuth.instance.signOut();
      context.read<AuthenticationBloc>().add(LoggedOut());
    }
  }

  @override
  void initState() {
    super.initState();
    _conf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appPrimaryBackground,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey, Colors.white])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/finance.svg',
              height: 220,
            ),
            SelectableText('Finoco',
                style: AppThemes.sectionTitleTextStyle.copyWith(fontSize: 40)),
          ],
        ),
      ),
    );
  }
}
