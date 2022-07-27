import 'package:rxdart/rxdart.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/database_class.dart';
import 'package:task_manager/services/entries/task_entry_model.dart';

import '../../model/entry_model.dart';
import '../../widgets/format.dart';
import 'daily_task_details.dart';
import 'entries_list_tile.dart';

class EntriesBloc {
  EntriesBloc({required this.database});
  final DatabaseClass database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<TaskEntryModel>> get _allEntriesStream => Rx.combineLatest2(
        database.readEntries(),
        database.readTasks(),
        _entriesJobsCombiner,
      );

  static List<TaskEntryModel> _entriesJobsCombiner(
    List<EntryModel> entries,
    List<TaskModel> jobs,
  ) {
    return entries.map((entry) {
      final task = jobs.firstWhere(
        (task) => task.taskId == entry.entryId,
        //orElse: () => null,
      );
      return TaskEntryModel(
        entry,
        task,
      );
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(
    List<TaskEntryModel> allEntries,
  ) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyJobsDetails = DailyTaskDetails.allTaskEntries(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map(
          (dateJobsDuration) => dateJobsDuration.taskDurationDet,
        )
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map(
          (dateJobsDuration) => dateJobsDuration.taskPayDet,
        )
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyTaskDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(
            dailyJobsDetails.taskDate,
          ),
          middleText: Format.currency(
            dailyJobsDetails.taskPayDet,
          ),
          trailingText: Format.hours(
            dailyJobsDetails.taskDurationDet,
          ),
        ),
        for (TaskDetails jobDuration in dailyJobsDetails.taskDetails)
          EntriesListTileModel(
            leadingText: jobDuration.taskDetName,
            middleText: Format.currency(
              jobDuration.payDetails,
            ),
            trailingText: Format.hours(
              jobDuration.durationInHours,
            ),
          ),
      ]
    ];
  }
}
