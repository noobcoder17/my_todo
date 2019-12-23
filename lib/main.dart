import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//screens
import './screens/new_user_screen.dart';
import './screens/loading_screen.dart';
import './screens/todo_app.dart';
import './screens/todos_screen.dart';

//providers
import 'package:my_todo/providers/home.dart';

void main(){ 
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>HomeProvider(),),
      ],
      child: Consumer<HomeProvider>(
        builder: (context,homeProvider,widget){
          return MaterialApp(
            color: Colors.white, 
            debugShowCheckedModeBanner: false,
            title: 'My ToDo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: homeProvider.isNewUser?  ToDo() : FutureBuilder(
              future: homeProvider.tryToGetData(),
              builder: (context,result){
                if(result.connectionState == ConnectionState.waiting){
                  return LoadingScreen();
                }else{
                  return NewUserScreen();
                }
              },
            ),
            routes: {
              ToDosScreen.routeName:(ctx)=>ToDosScreen()
            },
          );
        },
      ),
    );
  }
}