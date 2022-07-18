import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/database_class.dart';
import 'package:task_manager/widgets/display_alert_dialog.dart';
import 'package:task_manager/widgets/exception_alert.dart';

class NewTask extends StatefulWidget {
  final DatabaseClass database;
  final TaskModel? tasks;

  const NewTask({
    Key? key,
    required this.database,
    required this.tasks,
  }) : super(key: key);

  static Future<void> showNewPage(BuildContext context,
      {DatabaseClass? taskDB, TaskModel? task}) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewTask(
          database: taskDB!,
          tasks: task,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();

  String? _taskName;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.tasks != null) {
      _taskName = widget.tasks!.taskName;
      _ratePerHour = widget.tasks!.ratePerHour;
    }
  }

  bool _saveForm() {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  List<Widget> _formList() {
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Task Name:',
        ),
        initialValue: _taskName,
        onSaved: (val) => _taskName = val!,
        validator: (val) => val!.isNotEmpty ? null : "Field can't be empty",
      ),
      const SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Rate Per Hour:',
        ),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        onSaved: (val) => _ratePerHour = int.tryParse(val!)!,
        validator: (val) => val!.isNotEmpty ? null : "Field can't be empty",
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      ),
    ];
  }

  Widget _buildTaskForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _formList(),
      ),
    );
  }

  Widget _taskForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTaskForm(),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_saveForm()) {
      try {
        final taskCollection = await widget.database.readTasks().first;
        final jobNames = taskCollection.map((e) => e.taskName).toList();
        if (widget.tasks != null) {
          jobNames.remove(widget.tasks!.taskName);
        }
        if (jobNames.contains(_taskName)) {
          displayAlert(
            context,
            alertTitle: 'Name already in use',
            alertContent: 'Choose a different name',
            alertAction: 'OK',
          );
        } else {
          final id = widget.tasks?.taskId ?? taskDBID();
          final taskDetails = TaskModel(
            taskId: id,
            taskName: _taskName!,
            ratePerHour: _ratePerHour!,
          );
          await widget.database.assignTask(taskDetails);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (error) {
        errorAlert(
          context,
          errorTitle: 'Operation failed',
          errorMsg: error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tasks == null ? 'Add New Task' : 'Edit Task',
        ),
        actions: [
          FlatButton(
            onPressed: _submitForm,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _taskForm(),
      backgroundColor: Colors.grey[200],
    );
  }
}
