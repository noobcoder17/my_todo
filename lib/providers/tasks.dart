import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

import '../data/storage.dart' ;

class Tasks extends ChangeNotifier {
  StoreData storage = new StoreData();
  List<String> _types = [];
  List<Task> _tasks = [];


  Future<bool> createNewUserData() async {
    Map<String,dynamic> newUserData = {
      "userName" : "Akash Debnath",
      "typesList" : {},
      "tasks" : {}
    };

    try{
      File success = await storage.createNewUserFile(newUserData);
      if(success!=null){
        print("New User Created");
        return true;
      }
    }catch(e){
      print(e);
      print("New User Creation failed");
      return false;
    }
    return false;
  }


  Future<void> initializeTaskList() async {
    try{
      bool doesFileExits = await storage.fileExits();
      if(doesFileExits){
        String jsonData = await storage.getData();
        Map<String,dynamic> data = jsonDecode(jsonData);
        List<Task> tempList = [];
        Task tempTask;
        data.forEach((key,data){
          tempTask = new Task(
            id: data['id'].toString(),
            name: data['name'].toString(),
            isStar: data['isStar'],
            isDone: data['isDone']
          );
          tempList.add(tempTask);
        });
        _tasks = tempList;
      }
      print("Task initializatiion done");
      notifyListeners();
    }catch(e){
      print("Task initializatiion failed");
      print(e);
    }
  }

  List<Task> get getTasks{
    return [..._tasks];
  }


  Future<void> addTask(Task newTask) async {
    Map<String,dynamic> newJsonData = {
      newTask.id : newTask.toJson()
    };
    try {
      File success = await storage.postData(newJsonData);
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
      await storage.deleteData(key);
      print("task deleted");
      _tasks.removeWhere((task)=>task.id==key);
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}