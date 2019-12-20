import 'package:flutter/material.dart';

class TypesCard extends StatefulWidget {
  final double height;
  final double width;
  final String type;
  final int done;
  final int total;
  final Function deleteFunction;

  const TypesCard({
    Key key, 
    this.height, 
    this.width, 
    this.type, 
    this.done, 
    this.total,
    this.deleteFunction
  }) : super(key: key);

  
  @override
  _TypesCardState createState() => _TypesCardState();
}

class _TypesCardState extends State<TypesCard> {
  

  @override
  Widget build(BuildContext context) {
    //final taskProvider = Provider.of<TasksProvider>(context);
    return Container(
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
              Text("${widget.type}".toUpperCase(),style: TextStyle(fontSize: 25,color: Colors.black),),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  widget.deleteFunction(widget.type);
                }
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("You have ${widget.total - widget.done} tasks.",style: TextStyle(fontSize: 17),),
              SizedBox(height: 20,),
              LinearProgressIndicator(
                value: widget.total==0? 1 : widget.done==0? 0 : (widget.done/widget.total).toDouble(),
              )
            ],
          )
          //Text("${widget.total}"),
        ],
      ),
    );
  }
}