import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/tasks.dart';


class NewTaskDialog extends StatefulWidget {
  final TasksProvider tasksProvider;

  NewTaskDialog({
    this.tasksProvider
  });

  @override
  _NewTaskDialogState createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  String _taskName;


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
      bool success = await widget.tasksProvider.addIndividualTask(_taskName);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("Add new ToDo",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 20))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _form,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ToDo name",
              ),
              autocorrect: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              validator: (value){
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onChanged: (value){
                setState(() {
                  _taskName = value;
                });
              },
              onFieldSubmitted: (value){
                _onSubmit();
              },
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel",style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500))),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: _isLoading ? CircularProgressIndicator() : Text("Add",style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500)),),
          onPressed: (){
            _onSubmit();
          },
        ),
      ],
    );
  }
}