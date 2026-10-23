import 'package:finoco/features/auth/login/bloc/login_bloc.dart';
import 'package:finoco/features/auth/login/bloc/login_event.dart';
import 'package:finoco/features/devise/devises_page.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        // buildItem(
        //   context,
        //   'personalInfo',
        //   null,
        //   null,
        // ),
        buildItem(
          context,
          'Devise',
          const Icon(
            Icons.monetization_on_outlined,
            color: Color.fromRGBO(166, 179, 197, 1),
          ),
          () async {
            moreNavigatorKey.currentState.push(MaterialPageRoute(
              builder: (context) => DevisesPage(),
            ));
          },
        ),
        // buildItem(
        //   context,
        //   'password',
        //   const Icon(
        //     Icons.lock,
        //     color: Color.fromRGBO(166, 179, 197, 1),
        //   ),
        //   () async {},
        // ),
        // buildItem(
        //   context,
        //   'settings',
        //   null,
        //   null,
        // ),
        // buildItem(
        //   context,
        //   'language',
        //   const Icon(
        //     Icons.language,
        //     color: Color.fromRGBO(166, 179, 197, 1),
        //   ),
        //   null,
        //   null,
        // ),
        // buildItem(
        //   context,
        //   'customerSupport',
        //   const Icon(
        //     Icons.contact_support_outlined,
        //     color: Color.fromRGBO(166, 179, 197, 1),
        //   ),
        //   () async {},
        // ),
        // buildItem(
        //   context,
        //   'deleteAccount',
        //   const Icon(
        //     Icons.remove_circle_outline_sharp,
        //     color: Color.fromRGBO(166, 179, 197, 1),
        //   ),
        //   () async {
        //     await showDialog(
        //       context: context,
        //       builder: (context) => const DeleteAccountDialog(),
        //     );
        //   },
        // ),
        buildItem(
          context,
          'Se déconnecter',
          const Icon(
            Icons.logout,
            color: Color.fromRGBO(166, 179, 197, 1),
          ),
          () async {
            BlocProvider.of<LoginBloc>(context).add(SignOut());
          },
        ),
      ],
    );
  }

  Widget buildItem(
      BuildContext context, String title, Icon icon, VoidCallback press,
      [Widget suffix]) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: icon != null
              ? const Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(247, 247, 247, 1),
                    width: 1.5,
                  ),
                )
              : const Border(
                  top: BorderSide.none,
                ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) icon,
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight:
                          icon == null ? FontWeight.bold : FontWeight.w400,
                      color: const Color.fromRGBO(
                        2,
                        30,
                        63,
                        1,
                      ),
                    ),
                  ),
                ],
              ),
              suffix ??
                  (icon != null
                      ? const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color.fromRGBO(166, 179, 197, 1),
                        )
                      : const SizedBox())
            ],
          ),
        ),
      ),
      onTap: press,
    );
  }
}
