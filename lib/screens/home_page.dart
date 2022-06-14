import 'package:flutter/material.dart';
import '../services/authentication.dart';

class HomePage extends StatelessWidget {
  final AuthAbstract auth;
  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  void _signOutAnom() async {
    try {
      await auth.anomSignOut();
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
