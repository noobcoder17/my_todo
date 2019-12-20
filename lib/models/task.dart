import 'package:flutter/foundation.dart';

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
}