import 'package:flutter/material.dart';

import '../model/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.tasks, required this.onDelete});

  final List<Task> tasks;
  final Function(int position) onDelete;

  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.white, width: 1),
                   borderRadius: BorderRadius.circular(16)
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(task.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(task.description),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete, 
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      onDelete(index);
                    },
                  ),
                ),
              );
            },
          )
        : Center(
            child: const Text("Lista sem conteúdo"),
          );
  }
}
