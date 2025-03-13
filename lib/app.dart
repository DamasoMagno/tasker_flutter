import 'package:flutter/material.dart';
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

    Task newTask = Task(name: title.text, description: description.text);

    setState(() {
      tasks.add(newTask);
      filteredTasks = tasks; // Atualiza a lista filtrada


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

  void deleteTask(int taskPosition) {
    setState(() {
      tasks.removeAt(taskPosition);
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

class NewTask extends StatefulWidget {
  const NewTask({
    super.key,
    required this.title,
    required this.description,
    required this.onSave,
  });

  final TextEditingController title;
  final TextEditingController description;
  final Function onSave;

  @override
  State<NewTask> createState() => NewTaskState();
}

class NewTaskState extends State<NewTask> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            shape: Border.all(),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                height: 380,
                color: Colors.white10,
                child: Center(
                    child: SingleChildScrollView(
                        child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: widget.title,
                        decoration: const InputDecoration(
                          hintText: 'Nome da Tarefa',
                          labelStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16), // Adicionando espaçamento
                      TextField(
                        controller: widget.description,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Descrição da Tarefa',
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
                          onPressed: () {
                            widget.onSave();
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(
                                  Size(double.infinity, 48)),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)))),
                          child: const Text("Cadastrar Tarefa",
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ],
                  ),
                ))),
              );
            },
          );
        },
      ),
    ));
  }
}
