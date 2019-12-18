import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/storage.dart';

class Task extends ChangeNotifier {
  String id;
  String name;
  bool isDone;
  bool isStar;

  Task({
    this.id,
    this.name,
    this.isDone = false,
    this.isStar = false
  });

  toJson(){
    return {
      'id' : id,
      'name' : name,
      'isDone' : isDone,
      'isStar' : isStar
    };
  }

  Future<bool> updateTask() async {
    try{
      StoreData storage = new StoreData();
      Map<String,dynamic> newJsonData = {
        this.id : this.toJson()
      };
      File success = await storage.updateData(this.id, newJsonData);
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

  Future<void> toggleStar() async{
    bool isStarPrev = isStar;
    isStar = !isStar;
    try{
      bool updateSuccess = await updateTask();
      if(updateSuccess){
        print("Task star updated");
      }else{
        throw updateSuccess;
      }
    }catch(e){
      isStar = isStarPrev;
      print("${this.id} Task star update failed");
    }
    notifyListeners();
  }
}