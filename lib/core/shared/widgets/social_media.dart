import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/features/auth/login/bloc/login_bloc.dart';
import 'package:finoco/features/auth/login/bloc/login_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaWidgets extends StatelessWidget {
  const SocialMediaWidgets({
    Key? key,
    this.signIn = true,
  }) : super(key: key);
  final bool signIn;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<LoginBloc>(context).add(
              GoogleSignIn(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.appPrimaryBackground,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    signIn ? 'Goolgle sign in' : 'Google sign up',
                    style: AppThemes.bodyGreyTextStyle
                        .copyWith(color: const Color(0xff6c6c6c)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            BlocProvider.of<LoginBloc>(context).add(
              FacebookSignIn(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff0571dd),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/facebook.png',
                  height: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    signIn ? 'Facebook sign in' : 'Facebook sign up',
                    style: AppThemes.bodyGreyTextStyle
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            BlocProvider.of<LoginBloc>(context).add(
              AppleSignIn(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff0571dd),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/facebook.png',
                  height: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    'Apple',
                    style: AppThemes.bodyGreyTextStyle
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
