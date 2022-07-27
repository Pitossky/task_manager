import 'package:task_manager/services/entries/task_entry_model.dart';

/// Temporary model class to store the time tracked and pay for a job
class TaskDetails {
  TaskDetails({
    required this.taskDetName,
    required this.durationInHours,
    required this.payDetails,
  });
  final String taskDetName;
  double durationInHours;
  double payDetails;
}

/// Groups together all jobs/entries on a given day
class DailyTaskDetails {
  DailyTaskDetails({
    required this.taskDate,
    required this.taskDetails,
  });
  final DateTime taskDate;
  final List<TaskDetails> taskDetails;

  double get taskPayDet => taskDetails
      .map((taskDuration) => taskDuration.payDetails)
      .reduce((value, element) => value + element);

  double get taskDurationDet => taskDetails
      .map((taskDuration) => taskDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<TaskEntryModel>> _entriesByDate(
    List<TaskEntryModel> entries,
  ) {
    Map<DateTime, List<TaskEntryModel>> map = {};
    for (var taskEntry in entries) {
      final taskStart = DateTime(
        taskEntry.entry.start.year,
        taskEntry.entry.start.month,
        taskEntry.entry.start.day,
      );
      if (map[taskStart] == null) {
        map[taskStart] = [taskEntry];
      } else {
        map[taskStart]!.add(taskEntry);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyTaskDetails> allTaskEntries(
    List<TaskEntryModel> entries,
  ) {
    final byTaskDate = _entriesByDate(entries);
    List<DailyTaskDetails> taskEntryList = [];
    for (var date in byTaskDate.keys) {
      final entriesByDate = byTaskDate[date];
      final byTask = _jobsDetails(entriesByDate!);
      taskEntryList.add(
        DailyTaskDetails(
          taskDate: date,
          taskDetails: byTask,
        ),
      );
    }
    return taskEntryList.toList();
  }

  /// groups entries by job
  static List<TaskDetails> _jobsDetails(
    List<TaskEntryModel> entries,
  ) {
    Map<String, TaskDetails> taskDuration = {};
    for (var taskEntry in entries) {
      final entry = taskEntry.entry;
      final taskPay = entry.durationInHours * taskEntry.task.ratePerHour;
      if (taskDuration[entry.taskId] == null) {
        taskDuration[entry.taskId] = TaskDetails(
          taskDetName: taskEntry.task.taskName,
          durationInHours: entry.durationInHours,
          payDetails: taskPay,
        );
      } else {
        taskDuration[entry.taskId]!.payDetails += taskPay;
        taskDuration[entry.taskId]!.durationInHours += entry.durationInHours;
      }
    }
    return taskDuration.values.toList();
  }
}
