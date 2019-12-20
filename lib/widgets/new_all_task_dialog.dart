import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/home.dart';


class NewAllTaskDialog extends StatefulWidget {
  @override
  _NewAllTaskDialogState createState() => _NewAllTaskDialogState();
}

class _NewAllTaskDialogState extends State<NewAllTaskDialog> {
  final _form = GlobalKey<FormState>();
  String _type = 'common';
  String _taskName;
  bool _isLoading = false;

  Future<void> _onSubmit() async{
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      bool success = await Provider.of<HomeProvider>(context).addTaskFromHome(_type, _taskName);
      if(success){
        print("Add all task Dialog success, popping off");
      }
    }catch(e){
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _types = Provider.of<HomeProvider>(context).getTypes;
    List<DropdownMenuItem<String>> _items = []; 
    _types.forEach((type){
      DropdownMenuItem<String> item = new DropdownMenuItem(
        value: type.toString(),
        child: Text("$type"),
      );
      _items.add(item);
    });
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      title: Text("Add new task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                  autocorrect: true,
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value){
                    setState(() {
                      _taskName= value;
                    });
                  },
                ),
                SizedBox(height: 20,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                  value: _type,
                  items: _items,
                  onChanged: (val){
                    setState(() {
                      _type = val;
                    });
                  }, 
                ),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: _isLoading ? CircularProgressIndicator() : Text("Add"),
          onPressed: (){
            _onSubmit();
          },
        ),
      ],
    );
  }
}