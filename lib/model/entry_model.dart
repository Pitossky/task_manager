class EntryModel {
  String entryId;
  String taskId;
  DateTime start;
  DateTime end;
  String? comment;

  EntryModel({
    required this.entryId,
    required this.taskId,
    required this.start,
    required this.end,
    this.comment,
  });

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory EntryModel.fromMap(
    Map<dynamic, dynamic> value,
    String id,
  ) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return EntryModel(
      entryId: id,
      taskId: value['taskId'],
      start: DateTime.fromMillisecondsSinceEpoch(
        startMilliseconds,
      ),
      end: DateTime.fromMillisecondsSinceEpoch(
        endMilliseconds,
      ),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
