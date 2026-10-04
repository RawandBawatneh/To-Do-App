import 'package:flutter/material.dart';
import 'package:to_do_app/screens/completed_screen.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/profile_screen.dart';
import 'package:to_do_app/screens/todo_screen.dart';
import 'package:to_do_app/widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getScreen() {
    if (selectedIndex == 0) {
      return const HomeScreen();
    } else if (selectedIndex == 1) {
      return const TodoScreen();
    } else if (selectedIndex == 2) {
      return const CompletedScreen();
    } else {
      return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: changeScreen,
      ),
    );
  }
}