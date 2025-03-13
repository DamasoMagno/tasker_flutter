import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:task_flutter/components/new_task.dart';
import 'package:task_flutter/components/tasks_list.dart';
import 'package:task_flutter/model/task.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tasker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final title = TextEditingController();
  final description = TextEditingController();

  List<Task> tasks = [];
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList('tasks');

    if (tasksJson != null) {
      setState(() {
        tasks = tasksJson.map((taskStr) {
          Map<String, dynamic> taskMap = jsonDecode(taskStr);
          return Task.fromMap(taskMap);
        }).toList();
        filteredTasks = tasks;
      });
    }
  }

  Future<void> handleCreateNewTask() async {
    if (title.text.isEmpty || description.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Você deve informar o nome e a descrição"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"),
              )
            ],
          );
        },
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task newTask = Task(name: title.text, description: description.text);
    tasks.add(newTask);

    List<String> tasksJson =
        tasks.map((task) => jsonEncode(task.toMap())).toList();

    await prefs.setStringList('tasks', tasksJson);

    setState(() {
      filteredTasks = tasks;

      title.clear();
      description.clear();
    });
  }

  void handleDeleteTask(int taskPosition) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Você deve informar o nome e a descrição"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"),
              ),
              TextButton(
                onPressed: () {
                  deleteTask(taskPosition);
                  Navigator.pop(context);
                },
                child: const Text("Deletar"),
              ),
            ],
          );
        });
  }

  void deleteTask(int taskPosition) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tasks.removeAt(taskPosition);
    List<String> tasksJson =
        tasks.map((task) => jsonEncode(task.toMap())).toList();

    await prefs.setStringList("tasks", tasksJson);  
    
    setState(() {
      filteredTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title, style: const TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: null,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    filteredTasks = tasks
                        .where((task) => task.name.startsWith(value))
                        .toList();
                  } else {
                    filteredTasks = tasks;
                  }
                });
              },
              decoration: const InputDecoration(
                hintText: 'Buscar por nome...',
                labelStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
                alignment: Alignment.topRight,
                child: Text(
                  "${filteredTasks.length} tasks cadastradas",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                )),
            const SizedBox(height: 8),
            Expanded(
                child: TasksList(
                    tasks: filteredTasks, onDelete: handleDeleteTask)),
            NewTask(
                title: title,
                description: description,
                onSave: handleCreateNewTask)
          ],
        ),
      ),
    );
  }
}
