import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import 'package:my_todo/providers/home.dart';

//screen

class NewUserScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  bool _isLoading = false;

  void _createUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool isCreated = await Provider.of<HomeProvider>(context).createNewUserData();
      if(isCreated){
        //Navigator.of(context).pushReplacementNamed(ToDo.routeName);
      }else{
        showDialog(
          context: context,
          builder: (ctx){
            return AlertDialog();
          }
        ); 
      }
    }catch(e){
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New User Screen"),
      ),
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : RaisedButton(
          child: Text("Create New User"),
          onPressed: () {
            _createUser();
          },
        ),
      ),
    );
  }
}