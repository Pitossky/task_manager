import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/exports.dart';

class SignInPage extends StatelessWidget {
  final void Function(User?) anomSignIn;
  const SignInPage({
    Key? key,
    required this.anomSignIn,
  }) : super(key: key);

  void _anonymous() async {
    try {
      final anomUser = await FirebaseAuth.instance.signInAnonymously();
      anomSignIn(anomUser.user);
    } catch (e) {
      print(e.toString());
    }
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
        buttonFnc: _anonymous,
      ),
    );
  }
}
