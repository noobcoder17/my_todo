import 'package:flutter/material.dart';
class TypesCard extends StatefulWidget {
  final double height;
  final double width;

  TypesCard({
    this.height, 
    this.width
  });
  
  @override
  _TypesCardState createState() => _TypesCardState();
}

class _TypesCardState extends State<TypesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}