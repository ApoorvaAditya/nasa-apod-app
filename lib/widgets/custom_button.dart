import 'package:flutter/material.dart';
import 'package:nasa_apod_app/constants.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Icon? icon;

  const CustomButton({
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        icon: icon!,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          elevation: 10,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(0, 24, 57, 1),
        ),
        label: Text(
          text,
        ),
        onPressed: onPressed,
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: const Color.fromRGBO(0, 24, 57, 1),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: whiteTextStyle,
      ),
    );
  }
}
