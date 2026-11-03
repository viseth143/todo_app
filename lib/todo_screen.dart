import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/theme_cubit.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/todo_item_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController work = TextEditingController();

  void showTodoDialog({Todo? todo}) {
    final isEditing = todo != null;
    work.text = isEditing ? todo.title : '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Todo' : 'New Todo'),
          content: TextField(
            controller: work,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter todo"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = work.text.trim();
                if (text.isEmpty) return;
                if (isEditing) {
                  context.read<TodoBloc>().add(
                    EditTodo(id: todo.id, title: text),
                  );
                } else {
                  context.read<TodoBloc>().add(AddTodo(title: text));
                }
                Navigator.pop(dialogContext);
              },
              child: Text(isEditing ? "Save" : "Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    work.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDark) {
                return Switch(
                  value: isDark,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggle(value);
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text("No todos yet. Tap + to add one!"),
            );
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return Dismissible(
                key: ValueKey(todo.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<TodoBloc>().add(DeleteTodo(id: todo.id));
                },
                child: TodoItemScreen(
                  title: todo.title,
                  done: todo.done,
                  onToggle: (_) {
                    context.read<TodoBloc>().add(ToggleTodo(id: todo.id));
                  },
                  onEdit: () => showTodoDialog(todo: todo),
                  onDelete: () {
                    context.read<TodoBloc>().add(DeleteTodo(id: todo.id));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}