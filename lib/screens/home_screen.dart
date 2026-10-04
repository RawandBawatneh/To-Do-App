import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/add_task_screen.dart';
import 'package:to_do_app/tasky.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;

  List<TaskModel> tasks = [];
  List<TaskModel> highPriorityTasks = [];

  int completedTasks = 0;
  int achievementPercentage = 0;

  TaskModel? expandedTask;

  @override
  void initState() {
    super.initState();

    loadUser();
    loadTasks();
  }

  void loadUser() {
    final userBox = Hive.box<UserModel>(
      AppString.userBox,
    );

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    }
  }

  void loadTasks() {
    final taskBox = Hive.box<TaskModel>(
      AppString.taskBox,
    );

    tasks = taskBox.values.toList();

    highPriorityTasks = tasks
        .where(
          (task) => task.isHighPriority,
        )
        .toList();

    completedTasks = tasks
        .where(
          (task) => task.status == 'complete',
        )
        .length;

    if (tasks.isNotEmpty) {
      achievementPercentage =
          ((completedTasks / tasks.length) * 100).toInt();
    } else {
      achievementPercentage = 0;
    }
  }

  Future<void> openAddTaskScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddTaskScreen();
        },
      ),
    );

    setState(() {
      loadTasks();
    });
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
      loadTasks();
    });
  }

  void handleTaskStatus(
    TaskModel task,
  ) {
    changeTaskStatus(task);
  }

  Future<void> deleteTask(
    TaskModel task,
  ) async {
    await task.delete();

    setState(() {
      if (expandedTask == task) {
        expandedTask = null;
      }

      loadTasks();
    });
  }

  void handleDeleteTask(
    TaskModel task,
  ) {
    deleteTask(task);
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

  String getAchievementMessage() {
    if (achievementPercentage == 0) {
      return "Let's get started!";
    } else if (achievementPercentage < 50) {
      return "Keep going, you're doing great!";
    } else if (achievementPercentage < 100) {
      return 'Yuhuu, Your work is almost done!';
    } else {
      return 'Amazing, You did it!';
    }
  }

  double getAchievementValue() {
    return achievementPercentage / 100;
  }

  void changeTheme() {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.dark;
    }
  }

  IconData getThemeIcon() {
    if (themeNotifier.value == ThemeMode.dark) {
      return Icons.light_mode_outlined;
    }

    return Icons.dark_mode_outlined;
  }

  ImageProvider? getUserImage() {
    if (user != null && user!.imagePath.isNotEmpty) {
      final imageFile = File(
        user!.imagePath,
      );

      if (imageFile.existsSync()) {
        return FileImage(
          imageFile,
        );
      }
    }

    return null;
  }

  bool hasUserImage() {
    return getUserImage() != null;
  }

  Color getTaskTextColor(
    TaskModel task,
  ) {
    if (task.status == 'complete') {
      return Colors.grey;
    }

    return Theme.of(context).textTheme.bodyLarge?.color ??
        Colors.black;
  }

  TextDecoration getTaskDecoration(
    TaskModel task,
  ) {
    if (task.status == 'complete') {
      return TextDecoration.lineThrough;
    }

    return TextDecoration.none;
  }

  Widget buildTaskItem(
    TaskModel task,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(
        bottom: 10,
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
            value: task.status == 'complete',
            onChanged: (value) {
              handleTaskStatus(task);
            },
            activeColor: const Color(
              0xff15B86C,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    changeDescriptionVisibility(
                      task,
                    );
                  },
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: getTaskTextColor(
                        task,
                      ),
                      decoration: getTaskDecoration(
                        task,
                      ),
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
                        color: Colors.red,
                        fontSize: 12,
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
                      style: TextStyle(
                        color: task.status == 'complete'
                            ? Colors.grey
                            : null,
                      ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(
            16,
          ),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: getUserImage(),
                  child: hasUserImage()
                      ? null
                      : const Icon(
                          Icons.person,
                        ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        user?.motivationQuote ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: changeTheme,
                  icon: Icon(
                    getThemeIcon(),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),

            Text(
              'Good Morning, ${user?.name ?? 'User'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              getAchievementMessage(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
              padding: const EdgeInsets.all(
                20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Achieved Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          '$completedTasks Out of ${tasks.length} Done',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: getAchievementValue(),
                            strokeWidth: 7,
                            backgroundColor:
                                Theme.of(context).dividerColor,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              Color(
                                0xff15B86C,
                              ),
                            ),
                          ),
                        ),

                        Text(
                          '$achievementPercentage%',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              'High Priority Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (highPriorityTasks.isEmpty)
              const Text(
                'No high priority tasks',
              ),

            ...List.generate(
              highPriorityTasks.length,
              (index) {
                return buildTaskItem(
                  highPriorityTasks[index],
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'My Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (tasks.isEmpty)
              const Text(
                'No tasks yet',
              ),

            ...List.generate(
              tasks.length,
              (index) {
                return buildTaskItem(
                  tasks[index],
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: openAddTaskScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xff15B86C,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
                child: const Text(
                  'Add New Task',
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}