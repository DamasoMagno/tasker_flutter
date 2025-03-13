import 'package:flutter/material.dart';
import 'package:task_flutter/components/tasks_list.dart';
import 'tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final name = TextEditingController();
  final description = TextEditingController();

  List<Task> tasks = [
    Task(name: "Primeira task", description: "Descrição da primeira task")
  ];

  void handleCreateNewTask() {
    if (name.text.isEmpty || description.text.isEmpty) {
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
          });

      return;
    }

    setState(() {
      Task newTask = Task(name: name.text, description: description.text);
      tasks.add(newTask);

      name.clear();
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

  void deleteTask(int taskPosition) {
    setState(() {
      tasks.removeAt(taskPosition);
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
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nome da Tarefa',
                labelStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24), // Adicionando espaçamento
            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Descrição da Tarefa',
                labelStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24), // Espaçamento entre elementos
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleCreateNewTask,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)))),
                child: const Text("Cadastrar Tarefa",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ),
            const SizedBox(height: 15), // Mais espaçamento
            Expanded(child: TasksList(tasks: tasks, onDelete: handleDeleteTask))
          ],
        ),
      ),
    );
  }
}
