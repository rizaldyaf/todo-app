import "package:flutter/material.dart";

class TodoForm extends StatefulWidget {
  TodoForm({Key key, this.func}) : super(key: key);
  final Function func;

  @override
  _TodoForm createState() => _TodoForm();
}

class _TodoForm extends State<TodoForm> {
  String todo = "";


  void handleChange(text){
    setState((){
      todo = text;
    });
  }

  void handleDone(){
    widget.func(todo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title:Text("Create New"),
        actions: <Widget>[
          FlatButton(
            textColor:Colors.white,
            child: Text("Done"),
            onPressed: handleDone,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: TextField( 
          style:TextStyle(
            fontSize:20.0
          ),
          autofocus:true,
          onChanged:handleChange,
          onSubmitted: (text)=>handleDone(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: -5),
            labelText: 'What do you want to do?'
          ),
        )
      )
    );
  } 

}