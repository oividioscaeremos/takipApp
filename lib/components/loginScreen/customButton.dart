import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Function onPressed;
  CustomButton({this.text, this.buttonColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => onPressed(),
      child: Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
