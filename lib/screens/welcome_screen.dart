import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/screens/main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

 Future<void> getStarted() async {
  if (formKey.currentState!.validate()) {
    final userBox = Hive.box<UserModel>(AppString.userBox);

    await userBox.add(
      UserModel(
        name: fullNameController.text,
        motivationQuote: 'One task at a time. One step closer.',
        imagePath: '',
      ),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
      (route) => false,
    );
  }
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
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/tasky_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'to_do_app',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                const Center(
                  child: Text(
                    'Welcome To Tasky 👋🏻',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Your productivity journey starts here.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Image.asset(
                    'assets/images/welcome_image.png',
                    width: 300,
                    height: 300,
                  ),
                ),

                const Spacer(),

                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Sarah Khalid',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xff15B86C),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: getStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15B86C),
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Let's Get Started",style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}