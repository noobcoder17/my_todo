import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

import '../data/storage.dart' ;

class TasksProvider extends ChangeNotifier {
  StoreData storage = new StoreData();
  String _type;
  int _done = 0;
  List<Task> _tasks = [];

  TasksProvider(String type,Map<String,dynamic> tasks){
    _type = type;
    Task tempTask;
    List<Task> tempList = [];
    int _tempDone = 0;
    tasks.forEach((key,data){
      tempTask = new Task(
        id: data['id'].toString(),
        name: data['name'].toString(),
        type: data['type'].toString(),
        isDone: data['isDone']
      );
      if(tempTask.isDone){
        _tempDone +=1;
      }
      tempList.add(tempTask);
    });
    _done = _tempDone;
    _tasks = tempList;
  }
  
  String get getType{
    return _type;
  }

  int get getTotalDone {
    return _done;
  }

  int get getTotalTask {
    return _tasks.length;
  }

  List<Task> get getTasks{
    return [..._tasks];
  }

  Future<bool> addTask(Task newTask) async {
    Map<String,dynamic> newJsonData = {
      newTask.id : newTask.toJson()
    };
    try {
      File success = await storage.addTask(_type,newJsonData);
      if(success!=null){
        _tasks.add(newTask);
        print("Task added in individual provider");
        notifyListeners();
        return true;
      }
    }catch(e){
      print("Task adding failed");
      print(e);
      return false;
    }
    return false;
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