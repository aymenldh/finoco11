import 'package:finoco/core/authentication_bloc/authentication_bloc.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/auth/login/bloc/login_bloc.dart';
import 'package:finoco/features/auth/login/bloc/login_state.dart';
import 'package:finoco/features/more/more_screen.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../config/theme/colors.dart';

class More extends StatefulWidget {
  const More({Key key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: moreNavigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => BlocListener<LoginBloc, LoginState>(
                listener: (context, state) async {
                  if (state is LoginInitial) {
                    await EasyLoading.dismiss();

                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  } else if (state is Loading) {
                    await EasyLoading.show(
                      dismissOnTap: false,
                      indicator: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            'loading',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      maskType: EasyLoadingMaskType.black,
                    );
                  } else {
                    await EasyLoading.dismiss();
                  }
                },
                child: const ScaffoldHeader(
                  backgroundColor: AppColor.appSecondaryBackground,
                  screen: 3,
                  showBackButton: false,
                  title: 'Plus',
                  child: MoreScreen(),
                ),
              ),
            ));
  }

  // String getTextLang(e) {
  //   if (e == "ar") {
  //     return 'العربية';
  //   } else if (e == "fr") {
  //     return 'Français';
  //   } else {
  //     return 'English';
  //   }
  // }
}
