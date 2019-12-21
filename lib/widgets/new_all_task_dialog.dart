import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/home.dart';


class NewAllTaskDialog extends StatefulWidget {
  @override
  _NewAllTaskDialogState createState() => _NewAllTaskDialogState();
}

class _NewAllTaskDialogState extends State<NewAllTaskDialog> {
 
  final _form = GlobalKey<FormState>();
  String _type;
  String _taskName;
  bool _isLoading = false;

   @override
  void initState(){
    super.initState();
    _type = Provider.of<HomeProvider>(context,listen: false).getTypes[0];
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
      bool success = await Provider.of<HomeProvider>(context).addTaskFromHome(_type, _taskName);
      if(success){
        //print("Add all task Dialog success, popping off");
      }
    }catch(e){
      //print(e);
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
        child: Text("$type".toUpperCase()),
      );
      _items.add(item);
    });
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("Add new Todo",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 20))),
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
                    hintText: "Todo name",
                    border: OutlineInputBorder()
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
                  onFieldSubmitted: (value){
                    setState(() {
                      _taskName= value;
                    });
                  },
                ),
                SizedBox(height: 15,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      gapPadding: 0
                    )
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