import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//screens
import './screens/new_user_screen.dart';
import './screens/loading_screen.dart';
import './screens/todo_app.dart';
import './screens/add_task_screen.dart';

//providers
import './providers/tasks.dart';
import './providers/user.dart';

void main(){ 
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>Tasks(),),
        ChangeNotifierProvider(create: (ctx)=>UserProvider(),),
      ],
      child: Consumer<UserProvider>(
        builder: (context,userProvider,widget){
          return MaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'My ToDo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: userProvider.isNewUser?  ToDo() : FutureBuilder(
              future: userProvider.tryToGetData(),
              builder: (context,result){
                if(result.connectionState == ConnectionState.waiting){
                  return LoadingScreen();
                }else{
                  return NewUserScreen();
                }
              },
            ),
            routes: {
              AddTaskScreen.routeName:(ctx)=>AddTaskScreen()
            },
          );
        },
      ),
    );
  }
}