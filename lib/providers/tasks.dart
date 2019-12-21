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

  int get getTotalDone {
    int _tempDone = 0;
    _tasks.forEach((task){
      if(task.isDone){
        _tempDone +=1;
      }
    });
    return _tempDone;
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
        //print("Task added in individual provider");
        notifyListeners();
        return true;
      }
    }catch(e){
      //print("Task adding failed");
      //print(e);
      return false;
    }
    return false;
  }

  Future<bool> addIndividualTask(String taskName) async {
    Task newTask = new Task(
      id: DateTime.now().toString(),
      name: taskName,
      type: _type,
      isDone: false
    );
    
    Map<String,dynamic> newJsonData = {
      newTask.id : newTask.toJson()
    };
    try {
      File success = await storage.addTask(_type,newJsonData);
      if(success!=null){
        _tasks.add(newTask);
        //print("Task added in provider");
        notifyListeners();
        return true;
      }
    }catch(e){
      //print("Task adding failed");
      //print(e);
      return false;
    }
    return false;
  }

  Future<void> removeTask(String id) async {
    try{
      await storage.deleteTask(_type,id);
      //print("task deleted");
      _tasks.removeWhere((task)=>task.id==id);
      notifyListeners();
    }catch(e){
      //print(e);
    }
  }

  Future<bool> updateTask(Task task) async {
    try{
      StoreData storage = new StoreData();
      Map<String,dynamic> newJsonData = {
        task.id : task.toJson()
      };
      File success = await storage.updateTask(_type,task.id,newJsonData);
      if(success!=null){
        return true;
      }
    }catch(e){
      //print(e);
      return false;
    }
    return true;
  } 

  Future<void> toggleDone(String id) async {
    int index = _tasks.indexWhere((task)=>task.id==id);
    try{
      Task tempTask = _tasks[index];
      tempTask.isDone = !tempTask.isDone;
      bool updateSuccess = await updateTask(tempTask);
      if(updateSuccess){
        //_tasks[index].isDone = !_tasks[index].isDone;
        //print("$id Task done updated");
        notifyListeners();
      }else{
        throw updateSuccess;
      }
    }catch(e){
      //print("$id Task done update failed");
    }
    notifyListeners();
  }
}