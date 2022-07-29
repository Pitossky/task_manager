import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/model/task_model.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final task = TaskModel.fromMap(
        null,
        'abc',
      );
      expect(task, null);
    });

    test('tasks with all properties', () {
      final task = TaskModel.fromMap({
        'taskName': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(
          task,
          TaskModel(
            taskId: 'abc',
            taskName: 'Blogging',
            ratePerHour: 10,
          ));
    });

    test('missing taskName', () {
      final task = TaskModel.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(task, null);
    });
  });

  group('convertToMap', () {
    test('valid taskName, ratePerHour', () {
      final task = TaskModel(
        taskId: 'abc',
        taskName: 'Blogging',
        ratePerHour: 10,
      );
      expect(task.convertToMap(), {
        'taskName': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}
