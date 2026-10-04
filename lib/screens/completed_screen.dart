import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_task_item.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<TaskModel> completedTasks = [];

  TaskModel? expandedTask;

  @override
  void initState() {
    super.initState();
    loadCompletedTasks();
  }

  void loadCompletedTasks() {
    final taskBox = Hive.box<TaskModel>(
      AppString.taskBox,
    );

    completedTasks = taskBox.values
        .where(
          (task) => task.status == 'complete',
        )
        .toList();
  }

  Future<void> changeTaskStatus(
    TaskModel task,
  ) async {
    if (task.status == 'complete') {
      task.status = 'TODO';
    } else {
      task.status = 'complete';
    }

    await task.save();

    setState(() {
      if (expandedTask == task) {
        expandedTask = null;
      }

      loadCompletedTasks();
    });
  }

  void handleTaskStatus(
    TaskModel task,
  ) {
    changeTaskStatus(
      task,
    );
  }

  Future<void> deleteTask(
    TaskModel task,
  ) async {
    await task.delete();

    setState(() {
      if (expandedTask == task) {
        expandedTask = null;
      }

      loadCompletedTasks();
    });
  }

  void handleDeleteTask(
    TaskModel task,
  ) {
    deleteTask(
      task,
    );
  }

  void changeDescriptionVisibility(
    TaskModel task,
  ) {
    setState(() {
      if (expandedTask == task) {
        expandedTask = null;
      } else {
        expandedTask = task;
      }
    });
  }

  Widget getTaskItem(
    TaskModel task,
  ) {
    return CustomTaskItem(
      task: task,
      showDescription: expandedTask == task,
      onTitleTap: () {
        changeDescriptionVisibility(
          task,
        );
      },
      onStatusChanged: () {
        handleTaskStatus(
          task,
        );
      },
      onDelete: () {
        handleDeleteTask(
          task,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completed Tasks',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: completedTasks.isEmpty
            ? const Center(
                child: Text(
                  'No Completed Tasks',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(
                  16,
                ),
                itemCount: completedTasks.length,
                separatorBuilder: (
                  context,
                  index,
                ) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (
                  context,
                  index,
                ) {
                  final task = completedTasks[index];

                  return getTaskItem(
                    task,
                  );
                },
              ),
      ),
    );
  }
}