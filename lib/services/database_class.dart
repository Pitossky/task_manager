import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/api_path.dart';
import 'package:task_manager/services/firestore_service.dart';

import '../model/entry_model.dart';

abstract class DatabaseClass {
  Future<void> assignTask(TaskModel taskModel);
  Stream<List<TaskModel?>> readTasks();
  Future<void> deleteTask(TaskModel task);
  Stream<TaskModel?> editTaskStream({required String taskId});
  Future<void> setEntry(EntryModel entry);
  Future<void> deleteEntry(EntryModel entry);
  Stream<List<EntryModel>> readEntries({
    TaskModel? task,
  });
}

String taskDBID() => DateTime.now().toIso8601String();

class AppDatabase implements DatabaseClass {
  final String dbUserId;

  AppDatabase({required this.dbUserId});

  final _storeService = FirestoreService.firestoreServiceInstance;

  @override
  Future<void> assignTask(
    TaskModel taskModel,
  ) async =>
      await _storeService.setData(
        dbPath: APIPath.taskDBPath(
          dbUserId,
          taskModel.taskId,
        ),
        uid: dbUserId,
        dbData: taskModel.convertToMap(),
      );

  @override
  Stream<List<TaskModel?>> readTasks() => _storeService.collectionStream(
        path: APIPath.tasksPath(
          dbUserId,
        ),
        builder: (dbData, docId) => TaskModel.fromMap(
          dbData,
          docId,
        ),
      );

  @override
  Future<void> deleteTask(
    TaskModel task,
  ) async {
    final allEntries = await readEntries(task: task).first;
    for (EntryModel entry in allEntries) {
      if (entry.taskId == task.taskId) {
        await deleteEntry(entry);
      }
    }
    await _storeService.deleteData(
      docPath: APIPath.taskDBPath(
        dbUserId,
        task.taskId,
      ),
    );
  }

  @override
  Stream<TaskModel?> editTaskStream({
    required String taskId,
  }) =>
      _storeService.documentStream(
        path: APIPath.taskDBPath(
          dbUserId,
          taskId,
        ),
        builder: (dbData, docId) => TaskModel.fromMap(
          dbData!,
          docId,
        ),
      );

  @override
  Future<void> setEntry(
    EntryModel entry,
  ) async =>
      await _storeService.setData(
        dbPath: APIPath.entryIDPath(
          dbUserId,
          entry.entryId,
        ),
        uid: dbUserId,
        dbData: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(
    EntryModel entry,
  ) async =>
      await _storeService.deleteData(
        docPath: APIPath.entryIDPath(
          dbUserId,
          entry.entryId,
        ),
      );

  @override
  Stream<List<EntryModel>> readEntries({
    TaskModel? task,
  }) =>
      _storeService.collectionStream<EntryModel>(
        path: APIPath.entryPath(dbUserId),
        queryBuilder: task != null
            ? (query) => query.where(
                  'taskId',
                  isEqualTo: task.taskId,
                ) as Query<Map<String, dynamic>>
            : null,
        builder: (data, documentID) => EntryModel.fromMap(
          data,
          documentID,
        ),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
