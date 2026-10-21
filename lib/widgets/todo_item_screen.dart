import 'package:flutter/material.dart';

class TodoItemScreen extends StatelessWidget {
  final String title;
  final bool done;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TodoItemScreen({
    super.key,
    required this.title,
    required this.done,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: done, onChanged: onToggle),
        title: Text(title, style: TextStyle(decoration: done ? TextDecoration.lineThrough : TextDecoration.none),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
