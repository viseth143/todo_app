import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/widgets/todo_item_screen.dart';

class TodoScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  const TodoScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> todos = [
    {'id': 1, 'title': 'Learn Flutter', 'done': false},
    {'id': 2, 'title': 'Build a todo app', 'done': false},
  ];
  final TextEditingController work = TextEditingController();

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("todos", jsonEncode(todos));
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('todos');

    if (saved == null) return;

    final List decoded = jsonDecode(saved);
    setState(() {
      todos = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  void showTodoDialog({int? index}) {
    final isEditing = index != null;
    work.text = isEditing ? todos[index]['title'] : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Todo' : 'New Todo'),
          content: TextField(
            controller: work,
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter new todo"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = work.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  if (isEditing) {
                    todos[index]['title'] = text;
                  } else {
                    todos.add({
                      'id': DateTime.now().microsecondsSinceEpoch,
                      'title': text,
                      'done': false,
                    });
                  }
                });
                saveTodos();
                Navigator.pop(context);
              },
              child: Text(isEditing ? "Save" : "Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
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
        title: Text("My Todos"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch(
              value: widget.isDark,
              onChanged: widget.onThemeChanged,
            ),
          ),
        ],
      ),
      body:
          todos.isEmpty
              ? Center(child: Text("No Todos yet. Tap + to add to one"))
              : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(todos[index]['id']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        todos.removeAt(index);
                      });
                      saveTodos();
                    },
                    child: TodoItemScreen(
                      title: todos[index]['title'],
                      done: todos[index]['done'],
                      onToggle: (newValue) {
                        setState(() {
                          todos[index]['done'] = newValue;
                        });
                        saveTodos();
                      },
                      onEdit: () => showTodoDialog(index: index),
                      onDelete: () {
                        setState(() {
                          todos.removeAt(index);
                        });
                        saveTodos();
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
