import "package:flutter/material.dart";
// import "package:sqflite/sqflite.dart";
import "TodoForm.dart";

class MyHomePage extends StatefulWidget {
  //define 'props'
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // states
  var todosState    = [];
  var checkedState  = [];
  
  // methods
  void handleAddTodo(text) {
    setState((){
      todosState.add(text);
    });
  }

  void handleListTap(index) {
    if (!checkedState.contains(index)) {
      setState(()=>checkedState.add(index));
    } else {
      setState(()=>checkedState.remove(index));
    }
  }

  void handleDeleteTodo(index) {
      if (index >= 0  && index < todosState.length) {
        setState(()=>todosState.removeAt(index));
        if (checkedState.contains(index)) {
          setState(()=>checkedState.remove(index));
        }
      }
  }

  void openDialog(index) {
    String newTodo = todosState[index];

    void handleChange(text){
      setState(()=>newTodo = text);
    }

    showDialog(
      context:context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:Text("Edit"),
          content:TextField(
            controller: TextEditingController(text:newTodo),
            style:TextStyle(
              fontSize:20.0
            ),
            onChanged: (text)=>handleChange(text),
            decoration: InputDecoration(
              labelText: "What do you want to do?",
              contentPadding: EdgeInsets.symmetric(vertical: -5),
            ),
          ),
          actions:<Widget> [
            FlatButton(
              child:Text("Cancel"),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            RaisedButton(
              color: Colors.blue,
              child:Text("OK"),
              onPressed: (){
                updateTodo(index,newTodo);
                Navigator.of(context).pop();
              },
            ),
          ]
        );  
      }
    );
  }

  void updateTodo(index, text){
    setState(() {
      todosState[index] = text;
    });
  }

  @override //render
  Widget build(BuildContext context) {
    return Scaffold(
      appBar  : AppBar(
        title   : Text(widget.title),
      ),
      body: Center(
        child: todosState.length > 0 ?ListView.separated(
              itemCount   : todosState.length,
              itemBuilder : (context, index) {
                return ListTile(
                  leading   : IconButton(
                    onPressed   : ()=>handleListTap(index),
                    icon        : Icon(checkedState.contains(index)?Icons.check_box:Icons.check_box_outline_blank),
                  ),
                  title     : Text(todosState[index]),
                  trailing  : IconButton(
                    icon        : Icon(Icons.close),
                    onPressed   : ()=>handleDeleteTodo(index)
                  ),
                  onTap     : ()=>openDialog(index),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ):Text("No List")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoForm(func:handleAddTodo)),
            );
        },
        // onPressed :handleAddTodo,
        tooltip   : 'Add to list',
        child     : Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
