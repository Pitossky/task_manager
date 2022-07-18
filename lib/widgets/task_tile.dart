import 'package:flutter/material.dart';
import 'package:task_manager/model/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel tasks;
  final VoidCallback taskTap;

  const TaskTile({
    Key? key,
    required this.tasks,
    required this.taskTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tasks.taskName),
      trailing: const Icon(Icons.chevron_right),
      onTap: taskTap,
    );
  }
}
