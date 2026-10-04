import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/user_details_screen.dart';
import 'package:to_do_app/tasky.dart';
import 'package:to_do_app/screens/welcome_screen.dart';
import 'package:to_do_app/models/task_model.dart';

import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() {
    final userBox = Hive.box<UserModel>(AppString.userBox);

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    }
  }

  ImageProvider? getUserImage() {
    if (user != null && user!.imagePath.isNotEmpty) {
      final imageFile = File(user!.imagePath);

      if (imageFile.existsSync()) {
        return FileImage(imageFile);
      }
    }

    return null;
  }

  bool hasUserImage() {
    return getUserImage() != null;
  }

  Future<void> openUserDetails() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserDetailsScreen()),
    );

    setState(() {
      loadUser();
    });
  }

  void changeTheme(bool value) {
    if (value) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }

Future<void> logout() async {
  final userBox = Hive.box<UserModel>(
    AppString.userBox,
  );

  final taskBox = Hive.box<TaskModel>(
    AppString.taskBox,
  );

  await userBox.clear();
  await taskBox.clear();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const WelcomeScreen(),
    ),
    (route) => false,
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              const Text(
                'My Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 24),

              CircleAvatar(
                radius: 45,
                backgroundImage: getUserImage(),
                child: hasUserImage()
                    ? null
                    : const Icon(Icons.person, size: 45),
              ),

              const SizedBox(height: 12),

              Text(
                user?.name ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                user?.motivationQuote ?? 'One task at a time. One step closer.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile Info',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: openUserDetails,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline),

                      SizedBox(width: 12),

                      Expanded(child: Text('User Details')),

                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),

              const Divider(),

              Row(
                children: [
                  const Icon(Icons.dark_mode_outlined),

                  const SizedBox(width: 12),

                  const Expanded(child: Text('Dark Mode')),

                  Switch(
                    value: themeNotifier.value == ThemeMode.dark,
                    onChanged: changeTheme,
                    activeColor: const Color(0xff15B86C),
                  ),
                ],
              ),

              const Divider(),

              InkWell(
                onTap: logout,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.logout),

                      SizedBox(width: 12),

                      Expanded(child: Text('Log Out')),

                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
