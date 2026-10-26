# Todo App

A Flutter todo app with local storage and dark mode, built with the BLoC pattern.

## Features
- Add, edit, delete, and complete todos
- Swipe to delete
- Dark mode switch
- Todos saved locally and restored after restart

## Tech
- Flutter
- flutter_bloc
- equatable
- shared_preferences

## Architecture
- `models/`: the `Todo` model
- `bloc/`: `TodoBloc`, events, and state
- `widgets/`: reusable UI like the todo row
- The screen only sends events and displays state

## How to run
    flutter pub get
    flutter run