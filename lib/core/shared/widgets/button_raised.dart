import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:flutter/material.dart';

class ButtonRaised extends StatelessWidget {
  final String? title;
  final double width;
  final double height;
  final VoidCallback _onPressed;
  final bool enabled;
  final Color? color;
  final Icon? icon;
  final Color? textColor;
  const ButtonRaised({
    Key? key,
    this.title,
    this.width = double.infinity,
    this.height = 55.0,
    this.enabled = true,
    required VoidCallback onPressed,
    this.color,
    this.icon,
    this.textColor,
  })  : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? _onPressed : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: enabled
              ? color ?? AppColor.buttonBgColor
              : const Color(0xffADB3C9),
          border: Border.all(
              color: enabled
                  ? color ?? AppColor.buttonBgColor
                  : const Color(0xffADB3C9)),
          boxShadow: [
            enabled
                ? BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                : BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                  ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                if (icon != null && title != null)
                  const SizedBox(
                    width: 15,
                  ),
                if (title != null)
                  Text(
                    title!,
                    style: AppThemes.buttonText.copyWith(
                        color: textColor ??
                            (color != null
                                ? AppColor.appSecondaryColor
                                : Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
