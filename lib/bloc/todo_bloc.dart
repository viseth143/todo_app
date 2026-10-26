import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';
import 'package:todo_app/models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<LoadTodos>((event, emit) {
      onLoadTodo(event, emit);
    });
    on<AddTodo>((event, emit) {
      onAddTodo(event, emit);
    });
    on<EditTodo>((event, emit) {
      onEditTodo(event, emit);
    });
    on<DeleteTodo>((event, emit) {
      onDeleteTodo(event, emit);
    });
    on<ToggleTodo>((event, emit) {
      onToggleTodo(event, emit);
    });
  }

  Future<void> onLoadTodo(LoadTodos event, Emitter emit) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('todos');
    if (saved == null) return;

    final List decoded = jsonDecode(saved); // convert saved as a json into list of map
    emit(state.copyWith(todos: decoded.map((e) => Todo.fromJson(e)).toList())); // convert each map into obj
  }

  Future<void> onAddTodo(AddTodo event, Emitter emit) async {
    final newTodo = Todo(
      id: DateTime.now().microsecondsSinceEpoch,
      title: event.title,
      done: false,
    );
    emit(state.copyWith(todos: [...state.todos, newTodo]));
    await _save();
  }

  Future<void> onEditTodo(EditTodo event, Emitter emit) async {
    final updated =
        state.todos
            .map((t) => t.id == event.id ? t.copyWith(title: event.title) : t)
            .toList();
    emit(state.copyWith(todos: updated));
    await _save();
  }

  Future<void> onDeleteTodo(DeleteTodo event, Emitter emit) async {
    final update = state.todos.where((t) => t.id != event.id).toList();
    emit(state.copyWith(todos: update));
    await _save();
  }

  Future<void> onToggleTodo(ToggleTodo event, Emitter emit) async{
    final updated = state.todos.map((t) => t.id == event.id ? t.copyWith(done: !t.done) : t).toList();
    emit(state.copyWith(todos: updated));
    await _save();
  }


  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "todos",
      jsonEncode(state.todos.map((t) => t.toJson()).toList()),
    );
  }
}
