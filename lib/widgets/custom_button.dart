import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Icon icon;

  const CustomButton({this.text, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return RaisedButton.icon(
        icon: icon,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        textColor: Colors.white,
        elevation: 10,
        color: const Color.fromRGBO(0, 24, 57, 1),
        label: Text(
          text,
        ),
        onPressed: onPressed,
      );
    }
    return RaisedButton(
      elevation: 10,
      color: const Color.fromRGBO(0, 24, 57, 1),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
