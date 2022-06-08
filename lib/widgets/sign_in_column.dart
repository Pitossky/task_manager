import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/exports.dart';

class SignInColumn extends StatelessWidget {
  final VoidCallback buttonFnc;

  const SignInColumn({
    Key? key,
    required this.buttonFnc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            SignInButton(
              buttonImage: Image.asset('image/google_icon.png'),
              buttonTextColor: Colors.black,
              buttonColor: Colors.white,
              buttonText: 'Sign in with Google',
              buttonAction: () {},
            ),
            const SizedBox(height: 10),
            SignInButton(
              containerColor: Colors.white,
              buttonImage: Image.asset('image/facebook.png'),
              buttonTextColor: Colors.white,
              buttonColor: const Color(0xFF334D92),
              buttonText: 'Sign in with Facebook',
              buttonAction: () {},
            ),
            const SizedBox(height: 10),
            SignInButton(
              buttonImage: Image.asset('image/email.png'),
              buttonTextColor: Colors.white,
              buttonColor: Colors.blueGrey[500],
              buttonText: 'Sign in with Email',
              buttonAction: () {},
            ),
            const SizedBox(height: 30),
            SignInButton(
              buttonTextColor: Colors.white,
              buttonColor: Colors.blueGrey[700],
              buttonText: 'Sign in Anonymously',
              buttonAction: buttonFnc,
            ),
          ],
        ),
      ),
    );
  }
}

