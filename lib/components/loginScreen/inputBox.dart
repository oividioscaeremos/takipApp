import 'dart:ui';

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class InputBox extends StatefulWidget {
  final String labelText;
  final String id;
  final Function validate;
  final Function onChanged;
  final FocusNode focusNode;
  final IconData prefixIcon;
  final bool isObscure;
  final TextInputType inputType;

  bool showError;
  Color bgColor;
  Color onEnabledbgColor;

  InputBox(
      {this.labelText,
      this.id,
      this.validate,
      this.onChanged,
      this.bgColor,
      this.onEnabledbgColor,
      this.focusNode,
      this.prefixIcon,
      this.isObscure,
      this.showError,
      this.inputType});

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: () {
        UiOverlayStyle()
            .UiOverlayStyleBoth(Palette().colorPrimary, Brightness.light);
      },
      child: Container(
        width: 350,
        height: widget.showError ? 75 : 60,
        decoration: BoxDecoration(
          color: widget.bgColor,
        ),
        child: TextFormField(
          keyboardType:
              widget.inputType == null ? TextInputType.text : widget.inputType,
          focusNode: widget.focusNode,
          style: TextStyle(
            letterSpacing: 2,
            color: Palette().colorQuaternary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Palette().colorQuaternary.withAlpha(100),
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: Palette().colorQuaternary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ), // widget.labelText,
            focusColor: widget.onEnabledbgColor,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            prefixStyle: TextStyle(
              color: Palette().colorQuaternary.withOpacity(0.8),
            ),
          ),
          validator: (str) {
            return widget.validate(str);
          },
          onChanged: widget.onChanged,
          obscureText: widget.isObscure == null ? false : true,
        ),
      ),
    );
  }
}
