import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../models/task.dart';
import './add_task_screen.dart';

//providers
import '../providers/home.dart';
import '../providers/tasks.dart';

//widgets
import '../widgets/new_type_dialog.dart';

class ToDo extends StatefulWidget {
  static const routeName = '/todo-screen';
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  bool _isLoading = false;
  @override
  void initState(){
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<HomeProvider>(context,listen:false).initializeAllData(); 
    }catch(e){
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    List<TasksProvider> taskProviders = homeProvider.getTaskProviders;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Task"),
        bottom: CustomAppBar(homeProvider.getUserName),
      ),
      body: ListView.builder(
        itemCount: taskProviders.length,
        itemBuilder: (cyx,i){
          return ChangeNotifierProvider.value(
            value: taskProviders[i],
            child: ListTile(
              // onLongPress: (){
              //   taskProvider.removeTask(tasks[i].id);
              // },
              // leading: Text(tasks[i].name),
              // trailing: Consumer<Task>(
              //   builder: (ctx,task,widget){
              //     return IconButton(
              //       icon: task.isDone ? Icon(Icons.done,color: Colors.greenAccent,) : Icon(Icons.done,color: Colors.grey,),
              //       onPressed: task.toggleDone,
              //     );
              //   },
              // ),
            ),
          );
        },
      )
    );
  }
}


class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String _userName;
  CustomAppBar(String userName){
    _userName = userName.split(" ")[0];
  }
  final size = AppBar().preferredSize*2.4;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30,right: 20),
      height: size.height,
      width: AppBar().preferredSize.width,
      child: 
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Hello, $_userName.",style: TextStyle(color: Colors.white,fontSize: 32),),
              SizedBox(height: 15,),
              Text("Looks like feel good.",style: TextStyle(color: Colors.white70 ,wordSpacing: 1,fontSize: 15),),
              Text("Check what you want to finish today.",style: TextStyle(color: Colors.white70,wordSpacing: 1,fontSize: 15),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Today : september 12, 2019".toUpperCase(),style: TextStyle(color: Colors.white60,fontSize: 13),textAlign: TextAlign.left,),
                  Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.assignment,color: Colors.white,),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context){
                              return NewTypeDialog();
                            }
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline,color: Colors.white,),
                        onPressed: (){
                          Navigator.of(context).pushNamed(AddTaskScreen.routeName);
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => size;
}