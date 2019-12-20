import 'package:flutter/material.dart';
import 'package:my_todo/widgets/types_card.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../models/task.dart';
//screens
import './add_task_screen.dart';
import './loading_screen.dart';

//providers
import '../providers/home.dart';
import '../providers/tasks.dart';

//widgets
import '../widgets/new_type_dialog.dart';
import '../widgets/new_all_task_dialog.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final homeProvider = Provider.of<HomeProvider>(context);
    List<TasksProvider> taskProviders = homeProvider.getTaskProviders;
    return _isLoading ? LoadingScreen() : Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Task"),
        bottom: CustomAppBar(homeProvider.getUserName),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: taskProviders.length,
        itemBuilder: (cyx,i){
          return Column(
            children: <Widget>[
              ChangeNotifierProvider.value(
                value: taskProviders[i],
                child: Consumer<TasksProvider>(
                  builder: (ctx,task,widget){
                    return TypesCard(
                      height: height,
                      width: width,
                      type: task.getType,
                      done: task.getTotalDone,
                      total: task.getTotalTask,
                    );
                  },
                ),
              )
            ],
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
                          showDialog(
                            context: context,
                            builder: (context){
                              return NewAllTaskDialog();
                            }
                          );
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