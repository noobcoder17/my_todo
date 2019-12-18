import 'package:flutter/material.dart';
import '../values/gradients.dart';

import '../widgets/types_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final appBarHeight = AppBar().preferredSize.height;
    double leftPadding = (width-(width*0.75))/2;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradiants[0],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: appBarHeight*0.80,),
                Text("todo".toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                Container(
                  padding:  EdgeInsets.only(left: leftPadding,top: 25),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(),
                      SizedBox(height: 15,),
                      Text("Hello, Jane.",style: TextStyle(color: Colors.white,fontSize: 32),),
                      SizedBox(height: 13,),
                      Text("Looks like feel good.",style: TextStyle(color: Colors.white70 ,wordSpacing: 1,fontSize: 15),),
                      SizedBox(height: 2,),
                      Text("You have 3 tasks to do today.",style: TextStyle(color: Colors.white70,wordSpacing: 1,fontSize: 15),)
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: leftPadding,),
                  child: Align(alignment: Alignment.centerLeft,child: Text("Today : september 12, 2019".toUpperCase(),style: TextStyle(color: Colors.white60,fontSize: 13),textAlign: TextAlign.left,)),
                ),
                Container(
                  width: width,
                  height: (width*0.70*1.3)+20,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: leftPadding-10,right: leftPadding-10),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx,i){
                      return TypesCard(height: height,width: width,);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



