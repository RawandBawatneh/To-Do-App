import 'package:flutter/material.dart';
import 'package:to_do_app/screens/splash_screen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
  ThemeMode.light,
);

class Tasky extends StatelessWidget {
  const Tasky({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: themeMode,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            dividerColor: const Color(0xffE0E0E0),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xff1E1E1E),
            dividerColor: const Color(0xff444444),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}