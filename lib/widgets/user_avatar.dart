import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.userPhotoUrl,
    required this.photoRadius,
  }) : super(key: key);

  final String? userPhotoUrl;
  final double photoRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: photoRadius,
        backgroundColor: Colors.black12,
        backgroundImage:
            userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
        child: userPhotoUrl == null
            ? Icon(
                Icons.camera_alt,
                size: photoRadius,
              )
            : null,
      ),
    );
  }
}
