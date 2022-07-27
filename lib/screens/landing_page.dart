import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/home_page.dart';
import 'package:task_manager/screens/sign_in_page.dart';
import 'package:task_manager/screens/tab_page.dart';
import 'package:task_manager/services/authentication.dart';
import 'package:task_manager/services/database_class.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthAbstract>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authState(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.active) {
          final User? userData = snap.data;
          if (userData == null) {
            return SignInPage.createSignInBloc(context);
          }
          return Provider<DatabaseClass>(
            create: (_) => AppDatabase(
              dbUserId: userData.uid,
            ),
            child: const TabPage(),
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
