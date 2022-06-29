import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> displayAlert(
  BuildContext context, {
  required String alertTitle,
  required String alertContent,
  required String alertAction,
  String? cancelAction,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(alertTitle),
        content: Text(alertContent),
        actions: [
          if (cancelAction != null)
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelAction),
            ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(alertAction),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: [
        if (cancelAction != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelAction),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(alertAction),
        ),
      ],
    ),
  );
}
