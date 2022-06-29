import 'package:flutter/material.dart';
import '../widgets/exports.dart';

class SignInColumn extends StatelessWidget {
  final VoidCallback anonButton;
  final VoidCallback googleButton;
  final VoidCallback facebookButton;
  final VoidCallback emailNav;
  final bool? loadState;

  const SignInColumn({
    Key? key,
    required this.anonButton,
    required this.googleButton,
    required this.facebookButton,
    required this.emailNav,
    required this.loadState,
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
            SizedBox(
              height: 50,
                child: _header(loadState!),
            ),
            const SizedBox(height: 40),
            SignInButton(
              buttonImage: Image.asset('image/google_icon.png'),
              buttonTextColor: Colors.black,
              buttonColor: Colors.white,
              buttonText: 'Sign in with Google',
              buttonAction: loadState! ? null : googleButton,
            ),
            const SizedBox(height: 10),
            SignInButton(
              containerColor: Colors.white,
              buttonImage: Image.asset('image/facebook.png'),
              buttonTextColor: Colors.white,
              buttonColor: const Color(0xFF334D92),
              buttonText: 'Sign in with Facebook',
              buttonAction: loadState! ? null : facebookButton,
            ),
            const SizedBox(height: 10),
            SignInButton(
              buttonImage: Image.asset('image/email.png'),
              buttonTextColor: Colors.white,
              buttonColor: Colors.blueGrey[500],
              buttonText: 'Sign in with Email',
              buttonAction: loadState! ? null : emailNav,
            ),
            const SizedBox(height: 30),
            SignInButton(
              buttonTextColor: Colors.white,
              buttonColor: Colors.blueGrey[700],
              buttonText: 'Sign in Anonymously',
              buttonAction: loadState! ? null : anonButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(bool loadState) {
    if(loadState){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

