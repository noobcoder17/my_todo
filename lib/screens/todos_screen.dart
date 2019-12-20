import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/tasks.dart';


class ToDosScreen extends StatefulWidget {
  static const routeName = '/todos-screen';
  @override
  _ToDosScreenState createState() => _ToDosScreenState();
}

class _ToDosScreenState extends State<ToDosScreen> {
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = ModalRoute.of(context).settings.arguments as TasksProvider;
    return ChangeNotifierProvider.value(
      value: tasksProvider,
      child: Consumer<TasksProvider>(
        builder:(ctx,tasks,_){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(tasksProvider.getType.toUpperCase(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),),
              bottom: CustomAppBar(
                done: tasks.getTotalDone,
                total: tasks.getTotalTask,
              ),
            ),
            body: ListView.builder(
              itemCount: tasks.getTotalTask,
              itemBuilder: (ctx,i){
                return ListTile(
                  leading: Checkbox(
                    value: tasks.getTasks[i].isDone,
                    onChanged: (value){
                      tasksProvider.toggleDone(tasks.getTasks[i].id);
                    },
                  ),
                  title: Text(tasks.getTasks[i].name,style: TextStyle(decoration: tasks.getTasks[i].isDone ? TextDecoration.lineThrough : null),),
                  trailing: tasks.getTasks[i].isDone ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      tasksProvider.removeTask(tasks.getTasks[i].id);
                    },
                  ) : null,
                );
              },
            ),
          ); 
        }
      )
    );
  }
}


class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final int done;
  final int total;
  CustomAppBar({
    this.done,
    this.total,
  });
  final size = AppBar().preferredSize*1.5;
  final TextStyle style = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17,color: Colors.white));
  @override
  Widget build(BuildContext context) {
    int left = total-done;
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
            left==0? Text("All tasks done",style: style,): left==1?
            Text("You have $left task",style: style,): Text("You have $left tasks",style: style,) ,
            SizedBox(height: 20,),
            LinearProgressIndicator(
              //backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              value: total==0? 1 : done==0? 0 : (done/total).toDouble(),
            )
          ],
        ),
    );
  }

  @override
  Size get preferredSize => size;
}






// ListTile(
//             leading: Checkbox(
//               value: tasks[i].isDone,
//               onChanged: (value){
//                 tasks[i].toggleDone();
//               },
//             ),
//             title: Text(tasks[i].name,style: TextStyle(decoration: tasks[i].isDone ? TextDecoration.lineThrough : null),),
//             trailing: tasks[i].isDone ? IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: (){},
//             ) : null,
//           );