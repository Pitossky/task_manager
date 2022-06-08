import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback anomSignOut;
  const HomePage({
    Key? key,
    required this.anomSignOut,
  }) : super(key: key);

  void _signOutAnom() async {
    try {
      await FirebaseAuth.instance.signOut();
      anomSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home Page'),
        actions: [
          FlatButton(
            onPressed: _signOutAnom,
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
