import 'package:flutter/material.dart';

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
