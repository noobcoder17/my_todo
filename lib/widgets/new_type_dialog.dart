import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/home.dart';


class NewTypeDialog extends StatefulWidget {
  @override
  _NewTypeDialogState createState() => _NewTypeDialogState();
}

class _NewTypeDialogState extends State<NewTypeDialog> {
  final _form = GlobalKey<FormState>();
  List<String> _types;
  String _type;
  bool _isLoading = false;

   void initState(){
    super.initState();
    _types = Provider.of<HomeProvider>(context,listen: false).getTypes;
  }
  
  bool alreadyExists(String type){
    int index = _types.indexOf(type.toLowerCase());
    if(index==-1){
      return false;
    } 
    return true;
  }

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
      bool success = await Provider.of<HomeProvider>(context).addType(_type.toLowerCase());
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
      title: Text("Add new type of ToDo",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
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
                if(alreadyExists(value)){
                  return 'Type Already exists.';
                }
                return null;
              },
              onChanged: (value){
                setState(() {
                  _type = value;
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