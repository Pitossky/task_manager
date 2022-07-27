import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/services/database_class.dart';
import 'package:task_manager/widgets/exception_alert.dart';
import 'package:task_manager/widgets/task_builder.dart';
import '../model/entry_model.dart';
import '../model/task_model.dart';
import '../widgets/entry_list_item.dart';
import 'entry_page.dart';
import 'new_task.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({
    Key? key,
    required this.database,
    required this.job,
  });
  final DatabaseClass database;
  final TaskModel job;

  static Future<void> show(
    BuildContext context,
    TaskModel task,
  ) async {
    final database = Provider.of<DatabaseClass>(
      context,
      listen: false,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(
          database: database,
          job: task,
        ),
      ),
    );
  }

  Future<void> _deleteEntry(
    BuildContext context,
    EntryModel entry,
  ) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      errorAlert(
        context,
        errorTitle: 'Operation failed',
        errorMsg: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskModel>(
        stream: database.editTaskStream(
          taskId: job.taskId,
        ),
        builder: (context, snapshot) {
          final task = snapshot.data;
          final taskName = task?.taskName ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(taskName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => NewTask.showNewPage(
                    context,
                    task: job,
                    taskDB: database,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    task: job,
                    entry: null,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(
    BuildContext context,
    TaskModel job,
  ) {
    return StreamBuilder<List<EntryModel>>(
      stream: database.readEntries(task: job),
      builder: (context, snapshot) {
        return ListTaskBuilder<EntryModel>(
          snapshot: snapshot,
          taskBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.entryId}'),
              entryDismiss: entry,
              job: job,
              onDismissed: () => _deleteEntry(
                context,
                entry,
              ),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                task: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
