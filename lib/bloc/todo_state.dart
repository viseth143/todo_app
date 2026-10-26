import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;
  const TodoState({this.todos = const [], this.isLoading = false});

  TodoState copyWith({List<Todo>? todos, bool? isLoading}){
    return TodoState(todos: todos ?? this.todos, isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [todos, isLoading];
}

  