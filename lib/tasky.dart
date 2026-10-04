import 'package:flutter/material.dart';
import 'package:to_do_app/screens/splash_screen.dart';

ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

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
            scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xff1E1E1E),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}