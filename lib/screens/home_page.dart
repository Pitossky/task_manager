import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/widgets/display_alert_dialog.dart';
import '../services/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  void _signOutAnom(BuildContext context) async {
    try {
      final auth = Provider.of<AuthAbstract>(context, listen: false);
      await auth.anomSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final signOutReq = await displayAlert(
      context,
      alertTitle: 'Log Out',
      alertContent: 'Are you sure?',
      alertAction: 'Yes',
      cancelAction: 'Cancel',
    );
    if (signOutReq == true) {
      _signOutAnom(context);
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
            onPressed: () => _confirmSignOut(context),
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
