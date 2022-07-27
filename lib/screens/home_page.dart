import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screens/new_task.dart';
import 'package:task_manager/services/database_class.dart';
import 'package:task_manager/widgets/exception_alert.dart';
import 'package:task_manager/widgets/task_builder.dart';
import 'package:task_manager/widgets/task_tile.dart';
import 'job_entries_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  Widget _buildTaskCnts(BuildContext context) {
    final db = Provider.of<DatabaseClass>(context, listen: false);
    return StreamBuilder<List<TaskModel>>(
      stream: db.readTasks(),
      builder: (context, snap) {
        return ListTaskBuilder<TaskModel>(
          snapshot: snap,
          taskBuilder: (context, taskModel) => Dismissible(
            key: Key('task-${taskModel.taskId}'),
            direction: DismissDirection.endToStart,
            background: Container(
              //alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) => _deleteTaskId(
              context,
              taskModel,
            ),
            child: TaskTile(
              tasks: taskModel,
              taskTap: () => JobEntriesPage.show(
                context,
                taskModel,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteTaskId(
    BuildContext context,
    TaskModel task,
  ) async {
    try {
      final db = Provider.of<DatabaseClass>(
        context,
        listen: false,
      );
      await db.deleteTask(task);
    } on FirebaseException catch (error) {
      errorAlert(
        context,
        errorTitle: 'Operation failed',
        errorMsg: error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () => NewTask.showNewPage(
              context,
              task: null,
              taskDB: Provider.of<DatabaseClass>(
                context,
                listen: false,
              ),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildTaskCnts(context),
    );
  }
}
