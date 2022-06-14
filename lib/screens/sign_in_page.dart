import 'package:flutter/material.dart';
import 'package:task_manager/screens/email_screen.dart';
import 'package:task_manager/services/authentication.dart';
import '../widgets/exports.dart';

class SignInPage extends StatelessWidget {
  final AuthAbstract auth;

  const SignInPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  Future<void> _anonymous() async {
    try {
      await auth.anomSignIn();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _googleSignIn() async {
    try {
      await auth.googleSignIn();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      await auth.facebookSignIn();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailScreenNav(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EmailScreen(auth: auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Task Manager'),
        elevation: 0,
      ),
      body: SignInColumn(
        anonButton: _anonymous,
        googleButton: _googleSignIn,
        facebookButton: _facebookSignIn,
        emailNav: () => _emailScreenNav(context),
      ),
    );
  }
}
