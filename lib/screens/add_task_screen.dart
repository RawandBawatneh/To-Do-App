import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/custom_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isHighPriority = false;

  void changePriority(bool? value) {
    setState(() {
      isHighPriority = value ?? false;
    });
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter task title';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter task description';
    }

    return null;
  }

  Future<void> createTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final taskBox = Hive.box<TaskModel>(
      AppString.taskBox,
    );

    await taskBox.add(
      TaskModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: 'TODO',
        isHighPriority: isHighPriority,
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Title',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  CustomTextField(
                    controller: titleController,
                    hintText: 'Enter task title',
                    validator: validateTitle,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Enter task description',
                    validator: validateDescription,
                    maxLines: 4,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      const Text(
                        'High Priority',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Switch(
                        value: isHighPriority,
                        onChanged: changePriority,
                        activeThumbColor: const Color(
                          0xff15B86C,
                        ),
                      ),


                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  CustomButton(
                    text: 'Create Task',
                    onPressed: createTask,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}