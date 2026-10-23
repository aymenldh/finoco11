import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/devise/devises_screen.dart';
import 'package:flutter/material.dart';

class DevisesPage extends StatelessWidget {
  const DevisesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldHeader(
      screen: 2,
      title: 'Devises',
      child: DeviseScreen(),
    );
  }
}
