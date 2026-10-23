import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/authentication_bloc/authentication_bloc.dart';
import 'package:finoco/core/models/user.dart';
import 'package:finoco/core/repository/local_storage.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/auth/login/bloc/login_event.dart';
import 'package:finoco/features/auth/register/screen/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validators/validators.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _emailFormKey =
      GlobalKey<FormState>(debugLabel: 'e');
  final autoCompleteKey = GlobalKey<AutofillGroupState>();
  bool obscureTextPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String currentLang;

  bool _checkBoxValue = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is StoreUser) {
          await EasyLoading.dismiss();
          handleLoginSucceed(
            accessToken: state.accessToken,
            sub: state.sub,
          );
        } else if (state is SubmitLogin) {
          await EasyLoading.show(
            dismissOnTap: false,
            indicator: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                SelectableText(
                  'Loading',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is UserNotConfirmed) {
          await EasyLoading.dismiss();

          handleUserNotConfirmed(state.user);
        } else if (state is Failure) {
          await EasyLoading.dismiss();

          handleLoginFailed(state);
        } else if (state is ForceChangePassword) {
          await EasyLoading.dismiss();

          handleForceChangePassword(state);
        } else {
          await EasyLoading.dismiss();
        }
      },
      builder: (context, state) => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ScaffoldHeader(
              isNotLogged: true,
              backgroundColor: AppColor.appSecondaryBackground,
              showBackButton: false,
              bottomNavbar: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                child: ButtonRaised(
                  enabled: state is! SubmitLogin,
                  title: 'Connecter',
                  onPressed: _onFormSubmitted,
                ),
              ),
              title: 'Se connecter',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset('assets/finance_ill.jpg',
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Form(
                        key: _emailFormKey,
                        child: AutofillGroup(
                          key: autoCompleteKey,
                          onDisposeAction: AutofillContextAction.commit,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 40,
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  controller: _emailController,
                                  labelText: 'E-mail',
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'requiredField';
                                    }
                                    if (!isEmail(value)) {
                                      return 'emailInvalidError';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  labelText: 'Mot de passe',
                                  autofillHints: const [AutofillHints.password],
                                  onEditingComplete: () {
                                    TextInput.finishAutofillContext();
                                    if (_emailFormKey.currentState.validate()) {
                                      _emailFormKey.currentState.save();
                                      BlocProvider.of<LoginBloc>(context).add(
                                        Submitted(_emailController.text,
                                            _passwordController.text),
                                      );
                                    }
                                  },
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '_il10.requiredField(password)';
                                    }
                                    if (value.length < 8) {
                                      return 'passwordInvalidError';
                                    }
                                    return null;
                                  },
                                  obscureText: obscureTextPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  type: "password",
                                  onPressed: () {
                                    setState(() {
                                      obscureTextPassword =
                                          !obscureTextPassword;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 12.5,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _checkBoxValue,
                                        onChanged: (v) {
                                          setState(() {
                                            _checkBoxValue = v;
                                          });
                                        }),
                                    const Text('Rester connecté ?',
                                        style: AppThemes.kbirShwyTextStyle),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12.5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen()));
                                  },
                                  child: const Text('Nouveau à finoco ?',
                                      style: AppThemes.widgetsTitleTextStyle),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getTextLang(e) {
    if (e == "ar") {
      return 'العربية';
    } else if (e == "fr") {
      return 'Français';
    } else {
      return 'English';
    }
  }

  Future<void> _onFormSubmitted() async {
    navigateToHome(accessToken: "", sub: "");
    if (_emailFormKey.currentState.validate()) {
      await LocalStorage.getInstance().setSaveLogin(_checkBoxValue);
      _emailFormKey.currentState.save();
      BlocProvider.of<LoginBloc>(context).add(
        Submitted(_emailController.text, _passwordController.text),
      );
    }
  }

  void handleUserNotConfirmed(User user) {
    BlocProvider.of<AuthenticationBloc>(context).add(NotActivated(user));
  }

  void handleLoginSucceed({String sub, String accessToken}) {
    navigateToHome(sub: sub, accessToken: accessToken);
  }

  void navigateToHome({String accessToken, String sub}) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    BlocProvider.of<AuthenticationBloc>(context)
        .add(LoggedIn(sub, accessToken: accessToken));
    // context.read<ProfileBloc>().add(FetchProfile());
  }

  void handleLoginFailed(Failure state) {
    Duration dif = state.blockedUntil?.difference(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const SelectableText('wrongCredential'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }

  void handleForceChangePassword(LoginState state) {}
}
