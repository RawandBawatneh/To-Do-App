import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
    );
  }
}