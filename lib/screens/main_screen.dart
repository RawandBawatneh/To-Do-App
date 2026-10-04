import 'package:flutter/material.dart';
import 'package:to_do_app/screens/completed_screen.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/profile_screen.dart';
import 'package:to_do_app/screens/todo_screen.dart';

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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changeScreen,

        selectedItemColor: const Color(0xff15B86C),
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_outlined,
            ),
            activeIcon: Icon(
              Icons.list_alt,
            ),
            label: 'To Do',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            activeIcon: Icon(
              Icons.check_circle,
            ),
            label: 'Completed',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}