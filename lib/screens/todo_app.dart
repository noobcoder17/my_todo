import 'package:flutter/material.dart';
import 'package:my_todo/widgets/types_card.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


//screens
import './loading_screen.dart';

//providers
import '../providers/home.dart';
import '../providers/tasks.dart';

//widgets
import '../widgets/new_type_dialog.dart';
import '../widgets/new_all_task_dialog.dart';

//values
import '../values/values.dart' as values;


int date = DateTime.now().day;
int m = DateTime.now().month;
String month = values.months[m];
int year = DateTime.now().year;

class ToDo extends StatefulWidget {
  static const routeName = '/todo-screen';
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  bool _isLoading = false;
  bool _isListLoading = false;
  
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
      //print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> removeTypeCard(String type) async {
    setState(() {
      _isListLoading = true;
    });
    try {
      await Provider.of<HomeProvider>(context).deleteType(type); 
    }catch(e){
      //print(e);
    }
    setState(() {
      _isListLoading = false;
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
        elevation: 0,
        centerTitle: true,
        title: Text("My ToDo",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w600))),
        bottom: CustomAppBar(homeProvider.getUserName.split(" ")[0],homeProvider.getTypes.length),
      ),
      body: homeProvider.getTypes.length == 0 ? 
      Center(child: Text("No ToDo",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 20),)))
      : _isListLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),) :  
      ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: taskProviders.length,
        itemBuilder: (cyx,i){
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ChangeNotifierProvider.value(
                  value: taskProviders[i],
                  child: Consumer<TasksProvider>(
                    builder: (ctx,tasks,widget){
                      return TypesCard(
                        height: height,
                        width: width,
                        type: tasks.getType,
                        done: tasks.getTotalDone,
                        total: tasks.getTotalTask,
                        deleteFunction : removeTypeCard,
                        tasksProvider: taskProviders[i],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}


class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _userName;
  final int _typeCount;
  CustomAppBar(this._userName,this._typeCount);
  final size = AppBar().preferredSize*2.5;
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
              Text("Hello, $_userName",style: GoogleFonts.poppins(textStyle : TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w400),)),
              SizedBox(height: 15,),
              Text("Looks like feel good.",style: GoogleFonts.poppins( textStyle: TextStyle(color: Colors.white70 ,wordSpacing: 1,fontSize: 15)),),
              Text("Check what you want to finish today.",style: GoogleFonts.poppins( textStyle: TextStyle(color: Colors.white70 ,wordSpacing: 1,fontSize: 15)),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Today : $month $date, $year".toUpperCase(),style: GoogleFonts.poppins(textStyle:TextStyle(color: Colors.white60,fontSize: 13)),textAlign: TextAlign.left,),
                  Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.assignment,color: Colors.white,),
                        tooltip: "Add Type",
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
                        tooltip: "Add Todo",
                        onPressed: (){
                          if(_typeCount>=1){
                            showDialog(
                              context: context,
                              builder: (context){
                                return NewAllTaskDialog();
                              }
                            );
                          }else{
                            showDialog(
                              context: context,
                              builder: (ctx){
                                return AlertDialog(
                                  title: Text("First add a type",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 20))),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close",style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500))),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          }
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
  Size get preferredSize => size;
}