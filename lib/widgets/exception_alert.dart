import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/widgets/display_alert_dialog.dart';

Future<void> errorAlert(
  BuildContext context, {
  required String errorTitle,
  required Exception errorMsg,
}) =>
    displayAlert(
      context,
      alertTitle: errorTitle,
      alertContent: _excMsg(errorMsg).toString(),
      alertAction: 'OK',
    );

String? _excMsg(Exception exception){
  if (exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}
