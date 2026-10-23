import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchField extends StatefulWidget {
  final String _labelText;
  final String _hintText;
  final bool isTextArea;
  final Function _validator;
  final TextEditingController _controller;
  final TextInputType _keyboardType;
  final bool obscureText;
  final bool enabled;
  final List<TextInputFormatter> _formatter;
  final Function _tap;
  final Widget _icon;
  final String _type;
  final IconData _suffix;
  final Function _onPressed;
  final Color borderColor;
  final int minlines;
  final FocusNode focusNode;
  final int maxlines;
  final int maxLength;
  final TextInputAction textInputAction;
  final List<String> autofillHints;
  final Function() onEditingComplete;
  final Function(String value) onChanged;
  final String initalValue;

  final Color fillColor;
  const CustomSearchField({
    Key key,
    this.isTextArea = false,
    @required TextEditingController controller,
    TextInputType keyboardType,
    List<TextInputFormatter> formatter,
    this.textInputAction,
    Widget icon,
    IconData suffix,
    String Function(String) validator,
    Function onTap,
    Function onPressed,
    this.obscureText = false,
    this.enabled = true,
    String labelText,
    String hintText,
    String type,
    this.minlines,
    this.maxlines,
    this.maxLength,
    this.autofillHints,
    this.onEditingComplete,
    this.fillColor,
    this.onChanged,
    this.initalValue = '',
    this.borderColor,
    this.focusNode,
  })  : _labelText = labelText,
        _validator = validator,
        _tap = onTap,
        _suffix = suffix,
        _controller = controller,
        _formatter = formatter,
        _keyboardType = keyboardType,
        _icon = icon,
        _hintText = hintText,
        _type = type,
        _onPressed = onPressed,
        super(key: key);

  @override
  State<CustomSearchField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomSearchField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget._type == "password"
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      focusNode: widget.focusNode,
      // style: AppThemes.textFieldTextStyle,
      autocorrect: false,
      onChanged: widget.onChanged,
      enableSuggestions: false,
      onEditingComplete: widget.onEditingComplete,
      autofillHints: widget.autofillHints,
      textInputAction: widget.isTextArea == true
          ? TextInputAction.newline
          : widget.textInputAction ?? TextInputAction.next,
      minLines: widget.minlines ?? 1,
      maxLines: widget.maxlines ?? 1,
      controller: widget._controller,
      validator: widget._validator,
      enabled: widget.enabled,
      inputFormatters: widget._formatter,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      onTap: widget._tap,
      keyboardType: widget.isTextArea == true
          ? TextInputType.multiline
          : widget._keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColor.appSecondaryColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColor.appPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: AppColor.appPrimaryColor),
        ),
        filled: true,
        fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,
        labelText: widget._labelText,
        labelStyle: TextStyle(
          color: !widget.enabled
              ? AppColor.darkGray
              : widget.focusNode.hasFocus
                  ? AppColor.appPrimaryColor
                  : AppColor.appSecondaryColor,
        ),
        suffixIcon: widget._type == "password"
            ? IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: widget.focusNode.hasFocus
                      ? AppColor.appPrimaryColor
                      : widget._controller.text == widget.initalValue
                          ? AppColor.darkGray
                          : AppColor.appSecondaryColor,
                ),
                onPressed: widget._onPressed,
              )
            : widget._suffix != null
                ? IconButton(
                    onPressed: widget._onPressed,
                    icon: Icon(
                      widget._suffix,
                      color: widget.focusNode.hasFocus
                          ? AppColor.appPrimaryColor
                          : widget._controller.text == widget.initalValue
                              ? AppColor.darkGray
                              : AppColor.appSecondaryColor,
                    ),
                  )
                : null,
        prefixIcon: widget._icon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
    );
  }
}
