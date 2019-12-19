import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/storage.dart';

class Task extends ChangeNotifier {
  String id;
  String name;
  String type;
  bool isDone;

  Task({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.isDone,
  });

  toJson(){
    return {
      'id' : id,
      'name' : name,
      'type' : type,
      'isDone' : isDone,
    };
  }

  Future<bool> updateTask() async {
    try{
      StoreData storage = new StoreData();
      Map<String,dynamic> newJsonData = {
        this.id : this.toJson()
      };
      File success = await storage.updateTask(this.id, newJsonData);
      if(success!=null){
        return true;
      }
    }catch(e){
      print(e);
      return false;
    }
    return true;
  } 

  Future<void> toggleDone() async {
    bool isDonePrev = isDone;
    isDone = !isDone;
    try{
      bool updateSuccess = await updateTask();
      if(updateSuccess){
        print("Task done updated");
      }else{
        throw updateSuccess;
      }
    }catch(e){
      isDone = isDonePrev;
      print("${this.id} Task done update failed");
    }
    notifyListeners();
  }
}