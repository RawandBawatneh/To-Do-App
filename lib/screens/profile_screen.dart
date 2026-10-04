import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/user_details_screen.dart';
import 'package:to_do_app/screens/welcome_screen.dart';
import 'package:to_do_app/tasky.dart';

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
    final userBox = Hive.box<UserModel>(
      AppString.userBox,
    );

    if (userBox.isNotEmpty) {
      user = userBox.values.first;
    }
  }

  Future<void> openUserDetails() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const UserDetailsScreen();
        },
      ),
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

    setState(() {});
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
        builder: (context) {
          return const WelcomeScreen();
        },
      ),
      (route) => false,
    );
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

  bool isDarkMode() {
    return themeNotifier.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(
              height: 10,
            ),

            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundImage: getUserImage(),
                child: hasUserImage()
                    ? null
                    : const Icon(
                        Icons.person,
                        size: 55,
                      ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Center(
              child: Text(
                user?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Center(
              child: Text(
                user?.motivationQuote ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            const Text(
              'Profile Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(
                  14,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.person_outline,
                    ),
                    title: const Text(
                      'User Details',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: openUserDetails,
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.dark_mode_outlined,
                    ),
                    title: const Text(
                      'Dark Mode',
                    ),
                    trailing: Switch(
                      value: isDarkMode(),
                      onChanged: changeTheme,
                      activeColor: const Color(
                        0xff15B86C,
                      ),
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: logout,
                  ),
                ],
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