import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/home.dart';


class NewTypeDialog extends StatefulWidget {
  @override
  _NewTypeDialogState createState() => _NewTypeDialogState();
}

class _NewTypeDialogState extends State<NewTypeDialog> {
  final _form = GlobalKey<FormState>();
  String _type;
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
      bool success = await Provider.of<HomeProvider>(context).addType(_type);
      if(success){
        print("Add Dialog success, popping off");
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      title: Text("Add new card"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _form,
            child: TextFormField(
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
                  _type = value;
                });
              },
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