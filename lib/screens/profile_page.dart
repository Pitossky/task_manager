import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/widgets/user_avatar.dart';

import '../services/authentication.dart';
import '../widgets/display_alert_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _signOutAnom(BuildContext context) async {
    try {
      final auth = Provider.of<AuthAbstract>(
        context,
        listen: false,
      );
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

  Widget _userProfile(User? userProfile) {
    return Column(
      children: [
        UserAvatar(
          userPhotoUrl: userProfile!.photoURL,
          photoRadius: 50,
        ),
        const SizedBox(height: 8),
        if (userProfile.displayName != null)
          Text(
            userProfile.displayName.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthAbstract>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Profile'),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: _userProfile(auth.currentUser),
        ),
      ),
    );
  }
}
