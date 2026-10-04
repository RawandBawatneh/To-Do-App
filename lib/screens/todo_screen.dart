import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TaskModel> todoTasks = [];

  TaskModel? expandedTask;

  @override
  void initState() {
    super.initState();
    loadTodoTasks();
  }

  void loadTodoTasks() {
    final taskBox = Hive.box<TaskModel>(
      AppString.taskBox,
    );

    todoTasks = taskBox.values
        .where(
          (task) => task.status == 'TODO',
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

      loadTodoTasks();
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

      loadTodoTasks();
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
          'To Do Tasks',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: todoTasks.isEmpty
            ? const Center(
                child: Text(
                  'No To Do Tasks',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(
                  16,
                ),
                itemCount: todoTasks.length,
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
                  final task = todoTasks[index];

                  return getTaskItem(
                    task,
                  );
                },
              ),
      ),
    );
  }
}