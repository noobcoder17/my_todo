import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


//providers
import '../providers/tasks.dart';

//screen
import '../screens/todos_screen.dart';

class TypesCard extends StatefulWidget {
  final double height;
  final double width;
  final String type;
  final int done;
  final int total;
  final Function deleteFunction;
  final TasksProvider tasksProvider;

  const TypesCard({
    Key key, 
    this.height, 
    this.width, 
    this.type, 
    this.done, 
    this.total,
    this.deleteFunction,
    this.tasksProvider
  }) : super(key: key);

  
  @override
  _TypesCardState createState() => _TypesCardState();
}

class _TypesCardState extends State<TypesCard> {
  final TextStyle style = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17,color: Colors.black));
  @override
  Widget build(BuildContext context) {
    int left = widget.total - widget.done;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ToDosScreen.routeName,arguments:widget.tasksProvider);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        height: widget.width*0.75*1.2,
        width: widget.width*0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0,6),
              blurRadius: 4,
              spreadRadius: 3
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${widget.type}".toUpperCase(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 25,color: Colors.black)),),
                IconButton(
                  icon: Icon(Icons.delete,size: 21,color: Colors.redAccent,),
                  onPressed: (){
                    widget.deleteFunction(widget.type);
                  }
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                left==0? Text("All Todos done",style: style,): left==1?
                Text("You have $left Todo",style: style,): Text("You have $left Todos",style: style,) ,
                SizedBox(height: 20,),
                LinearProgressIndicator(
                  value: widget.total==0? 1 : widget.done==0? 0 : (widget.done/widget.total).toDouble(),
                )
              ],
            )
            //Text("${widget.total}"),
          ],
        ),
      ),
    );
  }
}