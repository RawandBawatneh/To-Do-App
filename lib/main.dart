import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/tasky.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  await Hive.openBox<UserModel>(AppString.userBox);
  await Hive.openBox<TaskModel>(AppString.taskBox);

  runApp(const Tasky());
}