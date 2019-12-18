import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../models/task.dart';
import './add_task_screen.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  void initState() {
    super.initState();
    Provider.of<Tasks>(context,listen:false).initializeTaskList();
  }
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<Tasks>(context);
    List<Task> tasks = taskProvider.getTasks;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Task"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              Navigator.of(context).pushNamed(AddTaskScreen.routeName);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (cyx,i){
          return ChangeNotifierProvider.value(
            value: tasks[i],
            child: ListTile(
              onLongPress: (){
                taskProvider.removeTask(tasks[i].id);
              },
              leading: Text(tasks[i].name),
              trailing: Consumer<Task>(
                builder: (ctx,task,widget){
                  return IconButton(
                    icon: task.isDone ? Icon(Icons.done,color: Colors.greenAccent,) : Icon(Icons.done,color: Colors.grey,),
                    onPressed: task.toggleDone,
                  );
                },
              ),
            ),
          );
        },
      )
    );
  }
}