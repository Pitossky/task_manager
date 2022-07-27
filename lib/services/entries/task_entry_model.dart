import 'package:task_manager/model/entry_model.dart';
import '../../model/task_model.dart';

class TaskEntryModel {
  TaskEntryModel(this.entry, this.task);

  final EntryModel entry;
  final TaskModel task;
}
