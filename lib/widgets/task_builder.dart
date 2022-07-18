import 'package:flutter/material.dart';
import 'package:task_manager/widgets/empty_task.dart';

typedef TaskBuilder<T> = Widget Function(
  BuildContext context,
  T taskItem,
);

class ListTaskBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>>? snapshot;
  final TaskBuilder<T>? taskBuilder;

  const ListTaskBuilder({
    Key? key,
    this.taskBuilder,
    this.snapshot,
  }) : super(key: key);

  Widget _buildTask(List<T> taskItems) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0 || index == taskItems.length + 1) {
          return Container();
        }
        return taskBuilder!(
          context,
          taskItems[index - 1],
        );
      },
      itemCount: taskItems.length + 2,
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot!.hasData) {
      final List<T>? taskItems = snapshot!.data;
      if (taskItems!.isNotEmpty) {
        return _buildTask(taskItems);
      } else {
        return const EmptyTask();
      }
    } else if (snapshot!.hasError) {
      return const EmptyTask(
        pageTitle: 'Something went wrong',
        pageMsg: "Can't load taskItems right now",
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
