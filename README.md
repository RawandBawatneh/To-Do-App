# ✅ Tasky - To-Do App

Tasky is a simple and clean Flutter To-Do application that helps users organize daily tasks, track progress, manage priorities, and personalize their profile.

The project was built using Flutter and focuses on practicing the main concepts covered in the course such as:

- Stateful & Stateless Widgets
- Navigation
- Forms & Validation
- Hive Local Storage
- Image Picker
- Theme Switching
- Reusable Widgets

---

## ✨ Features

- Create new tasks
- Mark tasks as completed
- Uncheck completed tasks and return them to To Do
- Delete tasks
- Mark tasks as High Priority
- Show or hide task description by tapping the task title
- Track completed tasks using a progress percentage
- Dynamic motivational messages based on progress
- Light and Dark Mode
- Edit user name and motivation quote
- Choose profile image from Gallery
- Capture profile image using Camera
- Save user data locally using Hive
- Save tasks locally using Hive
- Logout and clear user data and tasks

---

## 📱 Screens

The application includes:

- Splash Screen
- Welcome Screen
- Home Screen
- Add New Task Screen
- To Do Tasks Screen
- Completed Tasks Screen
- Profile Screen
- User Details Screen

---

## 🛠️ Technologies Used

- Flutter
- Dart
- Hive
- Hive Flutter
- Image Picker

---

## 📂 Project Structure

```text
lib/
│
├── models/
│   ├── task_model.dart
│   └── user_model.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── add_task_screen.dart
│   ├── todo_screen.dart
│   ├── completed_screen.dart
│   ├── profile_screen.dart
│   └── user_details_screen.dart
│
├── widgets/
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── custom_task_item.dart
│   └── custom_bottom_nav_bar.dart
│
├── app_string.dart
├── main.dart
└── tasky.dart
```

---

## 🎥 Demo

You can watch the application demo here:

[Watch Demo](demo.mp4)

> Make sure the video file is named `demo.mp4` and placed in the main project folder next to `README.md`.

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/RawandBawatneh/To-Do-App.git
```

Go to the project folder:

```bash
cd To-Do-App
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## 📦 Main Packages

```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
image_picker: ^1.2.3
```

---

## 💾 Local Storage

The project uses Hive to store:

- User information
- Profile image path
- Tasks
- Task status
- Task priority

This allows the data to remain available after closing and reopening the application.

---

## 🌙 Theme

Tasky supports both:

- Light Mode
- Dark Mode

The user can switch between themes directly from the application.

---

## 🎯 Task Progress

The Home Screen calculates the completion percentage based on:

```text
Completed Tasks / Total Tasks
```

The circular progress indicator updates automatically as tasks are completed or returned to the To Do list.

---

## 👩‍💻 Developer

Developed by **Rawand Bawatneh**

---

## 💚 About Tasky

Tasky was created as a Flutter training project to practice building a complete mobile application while applying navigation, local storage, forms, reusable widgets, state management, and responsive user interfaces.
