import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/services/taskServices.dart';

class TaskAdding extends StatefulWidget {
  const TaskAdding({super.key});

  @override
  State<TaskAdding> createState() => _TaskAddingState();
}

class _TaskAddingState extends State<TaskAdding> {
// text editing controller
  var _taskNameController = TextEditingController();
  var _taskDescriptionController = TextEditingController();
  var _taskDateController = TextEditingController();

// validation
  bool _validateName = false;
  bool _validateDescription = false;
  bool _validateDate = false;
  //
  var _taskServices = TaskServices();
  // clear Text field
  void clearText(){
    _taskNameController.text = '';
    _taskDescriptionController.text = '';
    _taskDateController.text = '';
  }
  // Validation


  final TextStyle selectedDateStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Add Task',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                // const Text(
                //   'Enter your Ta',
                //   style: TextStyle(
                //       fontSize: 25,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white70),
                // ),
                // TextField
                // Task name field
                TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter task Name',
                    hintStyle: const TextStyle(color: Colors.black54),
                    labelText: 'Task name',
                    labelStyle: const TextStyle(color: Colors.black54),
                    errorText: _validateName ? "Task name can\'t empty " : null,
                  ),
                  style: selectedDateStyle,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _taskDescriptionController,
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter task Description',
                    hintStyle: const TextStyle(color: Colors.black54),
                    labelStyle: const TextStyle(color: Colors.black54),
                    labelText: 'Task Description',
                    errorText:
                        _validateDescription ? "Task Description can\'t empty " : null,
                  ),
                  style: selectedDateStyle,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Date picker
                TextField(
                  controller: _taskDateController,
                  readOnly: true,
                  decoration: InputDecoration(

                    hintText: 'Enter task date',
                    hintStyle: const TextStyle(color: Colors.black54),
                    labelStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate:
                              DateTime(2100).add(const Duration(days: 365)),
                        );
                        final formattedDate =
                            DateFormat("dd-MM-yyyy").format(date!);
                        setState(() {
                          _taskDateController.text = formattedDate.toString();
                        });
                      },
                      icon: const Icon(
                        Icons.date_range_rounded,
                        color: Colors.black54,
                      ),

                    ),
                    errorText: _validateDate ? "Task Date can\'t empty " : null,
                  ),
                  style: selectedDateStyle,
                ),
                const SizedBox(
                  height: 20.0,
                ),
// submit button and clear button

                Row(
                  children: [
                    ElevatedButton(

                      style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,

                      ),
                      onPressed: () async {
                        setState(() {
                          _taskNameController.text.isEmpty?_validateName = true:_validateName = false;
                          _taskDescriptionController.text.isEmpty?_validateDescription= true: _validateDescription = false;
                          _taskDateController.text.isEmpty?_validateDate = true : _validateDate = false;

                        });
                        if(_validateName == false && _validateDescription == false && _validateDate == false) {
                          var _task = Task();
                          _task.name = _taskNameController.text;
                          _task.description = _taskDescriptionController.text;
                          _task.date = _taskDateController.text;
                          var result = await _taskServices.saveTask(_task);
                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Submit',style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,

                        ),
                        onPressed: () {
                      clearText();
                    }, child: const Text('clear',style: TextStyle(color: Colors.white),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
