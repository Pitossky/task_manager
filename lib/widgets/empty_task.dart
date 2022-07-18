import 'package:flutter/material.dart';

class EmptyTask extends StatelessWidget {
  final String pageTitle;
  final String pageMsg;

  const EmptyTask({
    Key? key,
    this.pageTitle = 'Nothing Here',
    this.pageMsg = 'Add a new item to get started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 32,
              color: Colors.black54,
            ),
          ),
          Text(
            pageMsg,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
