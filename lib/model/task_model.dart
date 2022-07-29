import 'dart:ui';

class TaskModel {
  final String taskId;
  final String taskName;
  final int ratePerHour;

  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.ratePerHour,
  });

  static TaskModel? fromMap(
    Map<String, dynamic>? dbData,
    String docId,
  ) {
    if (dbData == null) {
      return null;
    }

    final String? taskName = dbData['taskName'];
    if (taskName == null) {
      return null;
    }
    final int ratePerHour = dbData['ratePerHour'];
    return TaskModel(
      taskName: taskName,
      ratePerHour: ratePerHour,
      taskId: docId,
    );
  }

  Map<String, dynamic> convertToMap() {
    return {
      'taskName': taskName,
      'ratePerHour': ratePerHour,
    };
  }

  @override
  int get hashCode => hashValues(
        taskId,
        taskName,
        ratePerHour,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }
    final TaskModel otherTask = other as TaskModel;
    return taskId == otherTask.taskId &&
        taskName == otherTask.taskName &&
        ratePerHour == otherTask.ratePerHour;
  }

  @override
  String toString() =>
      'taskId: $taskId, taskName: $taskName, ratePerHour: $ratePerHour';
}
