import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task-screen';
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
    
  @override
  Widget build(BuildContext context) {
    final randomizer = new Random(); 
    int x = randomizer.nextInt(100);
    Task newTask = new Task(id: DateTime.now().toString(),name: "Task "+x.toString(),type: "home",isDone: false);
    final taskProvider = Provider.of<TasksProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Add Task"),
                onPressed:() {
                  taskProvider.addTask(newTask);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}