import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/main_screen.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/custom_text_field.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  Future<void> getStarted() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final userBox = Hive.box<UserModel>(
      AppString.userBox,
    );

    await userBox.add(
      UserModel(
        name: fullNameController.text.trim(),
        motivationQuote: 'One task at a time. One step closer.',
        imagePath: '',
      ),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MainScreen();
        },
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/tasky_logo.png',
                      width: 36,
                      height: 36,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    const Text(
                      'Tasky',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Image.asset(
                  'assets/images/welcome_image.png',
                  height: 220,
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(
                  'Welcome To Tasky',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Your daily task manager',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                CustomTextField(
                  controller: fullNameController,
                  hintText: 'Enter your full name',
                  validator: validateName,
                ),

                const SizedBox(
                  height: 24,
                ),

                CustomButton(
                  text: 'Get Started',
                  onPressed: getStarted,
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}