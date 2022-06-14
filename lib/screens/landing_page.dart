import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/home_page.dart';
import 'package:task_manager/screens/sign_in_page.dart';

import '../services/authentication.dart';

class LandingPage extends StatelessWidget {
  final AuthAbstract auth;
  const LandingPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authState(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.active) {
          final User? userData = snap.data;
          if (userData == null) {
            return SignInPage(
              auth: auth,
            );
          }
          return HomePage(
            auth: auth,
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
