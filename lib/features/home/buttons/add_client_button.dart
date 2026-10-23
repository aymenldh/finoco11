import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:flutter/material.dart';

class AddClientButton extends StatefulWidget {
  const AddClientButton({Key key}) : super(key: key);

  @override
  State<AddClientButton> createState() => _AddClientButtonState();
}

class _AddClientButtonState extends State<AddClientButton> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonRaised(
      onPressed: () async {
        await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (context) {
            return const CreateClientBottomSheet();
          },
        );
      },
      title: 'Ajouter client',
    );
  }
}

class CreateClientBottomSheet extends StatelessWidget {
  const CreateClientBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
