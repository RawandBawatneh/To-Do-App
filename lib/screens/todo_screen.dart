import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';

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
      expandedTask = null;
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

                  return Container(
                    padding: const EdgeInsets.all(
                      14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {
                            handleTaskStatus(
                              task,
                            );
                          },
                          activeColor: const Color(
                            0xff15B86C,
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  changeDescriptionVisibility(
                                    task,
                                  );
                                },
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              if (task.isHighPriority)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                    'High Priority',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),

                              if (expandedTask == task)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    task.description,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            handleDeleteTask(
                              task,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}