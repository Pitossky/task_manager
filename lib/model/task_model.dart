class TaskModel {
  final String taskId;
  final String taskName;
  final int ratePerHour;

  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.ratePerHour,
  });

  factory TaskModel.fromMap(
    Map<String, dynamic> dbData,
    String docId,
  ) {
    /*
    if (dbData == null) {
      return null;
    }
    */
    final String taskName = dbData['taskName'];
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
}
