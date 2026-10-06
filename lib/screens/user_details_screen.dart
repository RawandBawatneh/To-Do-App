import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/app_string.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/custom_text_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  UserModel? user;
  XFile? selectedImage;

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

      nameController.text = user!.name;
      quoteController.text = user!.motivationQuote;
    }
  }

  Future<void> pickImageFromGallery() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      selectedImage = image;
    });
  }

  Future<void> pickImageFromCamera() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      selectedImage = image;
    });
  }

  ImageProvider? getUserImage() {
    if (selectedImage != null) {
      return FileImage(
        File(selectedImage!.path),
      );
    }

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

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  String? validateQuote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your motivation quote';
    }

    return null;
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (user == null) {
      return;
    }

    user!.name = nameController.text.trim();
    user!.motivationQuote = quoteController.text.trim();

    if (selectedImage != null) {
      user!.imagePath = selectedImage!.path;
    }

    await user!.save();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: pickImageFromGallery,
                          icon: const Icon(
                            Icons.photo_library_outlined,
                          ),
                          label: const Text(
                            'Gallery',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xff15B86C,
                            ),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: pickImageFromCamera,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                          ),
                          label: const Text(
                            'Camera',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xff15B86C,
                            ),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const Text(
                    'User Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  CustomTextField(
                    controller: nameController,
                    hintText: 'Enter your name',
                    validator: validateName,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Motivation Quote',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  CustomTextField(
                    controller: quoteController,
                    hintText: 'Enter your motivation quote',
                    validator: validateQuote,
                    maxLines: 5,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  CustomButton(
                    text: 'Save Changes',
                    onPressed: saveChanges,
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