import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputBox extends StatefulWidget {
  final String labelText;
  final String id;
  final Function validate;
  final Function onChanged;
  Color bgColor;
  Color onEnabledbgColor;

  InputBox(
      {this.labelText,
      this.id,
      this.validate,
      this.onChanged,
      this.bgColor,
      this.onEnabledbgColor});

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: 350,
      height: 60,
      decoration: BoxDecoration(
        color: widget.bgColor,
      ),
      child: TextFormField(
        style: TextStyle(
          letterSpacing: 2,
          color: Palette().white,
        ),
        onEditingComplete: () {
          setState(() {
            widget.bgColor = widget.bgColor;
          });
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Palette().white,
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
            color: Palette().white.withOpacity(0.8),
          ),
        ),
        validator: (str) {
          return widget.validate(str);
        },
        onChanged: widget.onChanged,
      ),
    );
  }
}
