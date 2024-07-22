import 'package:flutter/material.dart';
import 'package:todo_app/screens/taskAdding.dart';
import 'package:todo_app/services/taskServices.dart';

import '../model/task.dart';
import 'editTask.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.orange),
        ),
      ),
    );
  }

  late List<Task> _tasksList;
  final _taskServices = TaskServices();

  getAllTaskDetails() async {
    _tasksList = <Task>[];
    var tasks = await _taskServices.readAllTask();

    tasks.forEach((task) {
      setState(() {
        var taskModel = Task();
        taskModel.id = task['id'];
        taskModel.name = task['name'];
        taskModel.description = task['description'];
        taskModel.date = task['date'];
        _tasksList.add(taskModel);
      });
    });
  }

  @override
  void initState() {
    getAllTaskDetails();
    super.initState();
  }

  _deleteFormDialog(BuildContext context, taskId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await _taskServices.deleteTask(taskId);
                if (result != null) {
                  setState(() {
                    getAllTaskDetails();
                  });
                  Navigator.pop(context);
                }
              },
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Task',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const TaskAdding(),
            ),
          ).then((data) {
            if (data != null) {
              getAllTaskDetails();
              _showSuccessSnackBar('Task added');
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _tasksList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.yellow.shade300,
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _tasksList[index].name ?? '',
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                  subtitle: Text(
                    _tasksList[index].description ?? '',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        _tasksList[index].date ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: _tasksList[index].isChecked ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _tasksList[index].isChecked = value;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditTask(
                                task: _tasksList[index],
                              ),
                            ),
                          ).then(
                            (data) {
                              if (data != null) {
                                getAllTaskDetails();
                                _showSuccessSnackBar('Task edited');
                              }
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _deleteFormDialog(context, _tasksList[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
