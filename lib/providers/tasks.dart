import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

import '../data/storage.dart' ;

class TasksProvider extends ChangeNotifier {
  StoreData storage = new StoreData();
  String _type;
  List<Task> _tasks = [];

  TasksProvider(String type,Map<String,dynamic> tasks){
    _type = type;
    Task tempTask;
    List<Task> tempList = [];
    tasks.forEach((key,data){
      tempTask = new Task(
        id: data['id'].toString(),
        name: data['name'].toString(),
        type: data['type'].toString(),
        isDone: data['isDone']
      );
      tempList.add(tempTask);
    });
    _tasks = tempList;
  }

  String get getType{
    return _type;
  }

  List<Task> get getTasks{
    return [..._tasks];
  }

  Future<void> addTask(Task newTask) async {
    Map<String,dynamic> newJsonData = {
      newTask.id : newTask.toJson()
    };
    try {
      File success = await storage.addTask(newJsonData);
      if(success!=null){
        print("Task added");
        _tasks.add(newTask);
      }
    }catch(e){
      print("Task adding failed");
      print(e);
    }
  }

  Future<void> removeTask(String key) async {
    try{
      await storage.deleteTask(key);
      print("task deleted");
      _tasks.removeWhere((task)=>task.id==key);
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}