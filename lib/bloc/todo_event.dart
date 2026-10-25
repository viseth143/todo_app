abstract class TodoEvent {}

class LoadTodo extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo({required this.title});
}

class EditTodo extends TodoEvent {
  final int id;
  final String title;
  EditTodo({required this.id, required this.title});
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo({required this.id});
}

class ToggleTodo extends TodoEvent {
  final int id;
  ToggleTodo({required this.id});
}
