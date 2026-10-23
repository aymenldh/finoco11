import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback _onPressed;
  final bool enabled;

  const SocialButton(
      {Key key,
      @required this.child,
      this.width = double.infinity,
      this.height = 55.0,
      this.enabled = true,
      @required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: enabled ? _onPressed : null,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
