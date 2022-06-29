import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? buttonAction;
  final Color? buttonColor;
  final Color buttonTextColor;
  final Widget? buttonImage;
  final Color? containerColor;

  const SignInButton({
    Key? key,
    required this.buttonText,
    required this.buttonAction,
    required this.buttonColor,
    required this.buttonTextColor,
    this.buttonImage,
    this.containerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: RaisedButton(
        disabledColor: buttonColor,
        color: buttonColor,
        onPressed: buttonAction,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: containerColor,
              height: 40.0,
              width: 40.0,
              child: buttonImage,
            ),
            const SizedBox(width: 20),
            Text(
              buttonText,
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
