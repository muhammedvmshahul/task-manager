

import 'package:todo_app/db_helper/repository.dart';
import 'package:todo_app/model/task.dart';

@override
class TaskServices {

 late Repository _repository;
 TaskServices(){
   _repository = Repository();
 }
// save data
 saveTask(Task task)async{
   return await _repository.insertData('tasks',task.taskMap());
 }
 // read all data

readAllTask()async{
   return await _repository.readData('tasks');
}

  updateTask(Task task)async {
   final taskId = task.id??0;
   return await _repository.updateData('tasks', task.taskMap(),taskId);
  }

  deleteTask(taskId) async{
   return await _repository.deleteDataById('tasks', taskId);
  }
  // Update task status



}
