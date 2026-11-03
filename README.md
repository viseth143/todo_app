# Todo App

A Flutter todo app with local storage and dark mode, built with the BLoC pattern.

## Screenshots

| Light | Dark | Edit |
|-------|------|------|
| <img src="screenshots/light.png" width="200"> | <img src="screenshots/dark_mode.png" width="200"> | <img src="screenshots/edit.png" width="200"> |

## Features

- Add, edit, delete, and complete todos
- Swipe a todo to delete it
- Dark mode switch
- Todos are saved on the device and restored after restart

## Tech

- Flutter
- flutter_bloc (state management)
- equatable
- shared_preferences (local storage)

## Project structure

    lib/
      bloc/       TodoBloc, events, and state
      models/     Todo model
      widgets/    reusable UI (the todo row)
      todo_screen.dart

## How it works

The screen only sends events (AddTodo, EditTodo, ToggleTodo, DeleteTodo) and displays the state. TodoBloc updates the list and saves it in one place.

## How to run

    flutter pub get
    flutter run