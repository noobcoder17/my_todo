import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/storage.dart';


//models
import '../models/task.dart';
import './tasks.dart';

class HomeProvider extends ChangeNotifier {
  StoreData storage = new StoreData();

  
  bool _isNewUser;
  String _userName;
  List<String> _types = [];
  Map<String,TasksProvider> _taskProviders = {};

  bool get isNewUser {
    return _isNewUser!=null;
  }

  String get getUserName {
    return _userName;
  }

  List<String> get getTypes{
    return [..._types];
  }

  List<TasksProvider> get getTaskProviders {
    List<TasksProvider> tempList = [];
    _taskProviders.forEach((type,taskProvider){
      tempList.add(taskProvider);
    });
    return tempList;
  }

  Future<bool> addTaskFromHome(String type,String taskName) async {
    Task newTask = new Task(
      id: DateTime.now().toString(),
      name: taskName,
      type: type,
      isDone: false
    );
    TasksProvider tasksProvider = _taskProviders[type];
    try {
      bool success = await tasksProvider.addTask(newTask);
      if(success){
        print("Task added from home");
        return true;
      }else{
        return false;
      }
    }catch(e){
      print("Task adding failed");
      print(e);
      return false;
    }
  }

  Future<bool> addType(String type) async{
    int isAlready = _types.indexOf(type);
    if(isAlready>=0){
      return true;
    }
    try {
      File newFile = await storage.addType(type);
      if(newFile!=null){
        print("$type Type added");
        _types.add(type);
        TasksProvider _newTasksProvider = TasksProvider(type,{});
        _taskProviders.addAll({type:_newTasksProvider});
        notifyListeners();
        return true;
      }
    }catch(e){
      print("Type adding failed");
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> deleteType(String type) async {
    try{
      File success = await storage.remoreType(type);
      if(success!=null){
        _taskProviders.remove(type);
        _types.remove(type);
        print("Type remove successful");
        notifyListeners();
        return true;
      }else{
        return false;
      }
    }catch(e){
      print("Type remove failed");
      print(e);
      return false;
    }
  }


  Future<void> initializeAllData() async {
    try{
      bool doesFileExits = await storage.fileExits();
      if(doesFileExits){
        String jsonData = await storage.getData();
        Map<String,dynamic> data = jsonDecode(jsonData);

        //assigning data
        _userName = data['userName'];
        List<String> tempTypes = [];
        data['types'].forEach((dynamic type){
          tempTypes.add(type.toString());
        });
        _types = tempTypes;
        Map<String,TasksProvider> tempList = {};
        _types.forEach((type){
          print("type:$type");
          Map<String,dynamic> _eachType = data['tasks'][type];
          TasksProvider _newTasksProvider = TasksProvider(type,_eachType);
          tempList.addAll({type:_newTasksProvider});
        });
        _taskProviders = tempList;
      }
      print("All initializatiion done");
      notifyListeners();
    }catch(e){
      print("Initializatiion failed");
      print(e);
    }
  }


  Future<bool> createNewUserData() async {
    Map<String,dynamic> newUserData = {
      "userName" : "Akash Debnath",
      "types" : ["common"],
      "tasks" : {
        "common" : {
          DateTime.now().toString() : Task(id: DateTime.now().toString(),type: "common",name: "Common 1",isDone: false)
        }
      }
    };
    try{
      File success = await storage.createNewUserFile(newUserData);
      if(success!=null){
        print("New User Created");
        _isNewUser = true;
        notifyListeners();
        return true;
      }
    }catch(e){
      print(e);
      print("New User Creation failed");
      return false;
    }
    return false;
  }

   Future<bool> tryToGetData() async {
    bool doesUserExists = await storage.fileExits();
    if(doesUserExists==false){
      return false;
    }
    _isNewUser = true;
    notifyListeners();
    return true;
  }
}