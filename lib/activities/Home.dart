import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/activities/TestPage.dart';
import "TodoForm.dart";
import "Todos.dart";

class MyHomePage extends StatefulWidget {
  //define 'props'
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();

  // states
  
  var todosState            = [];
  var checkedState          = [];
  int _currentIndex         = 0; 
  final List<Widget> _pages = [
    null,
    Todos(),
    Todos(),
    Todos(),
  ];

  void onTabTapped(index){
    setState((){
      _currentIndex = index;
    });
  }

  @protected
  @mustCallSuper
  void initState(){
    super.initState();
    getData().then((result){
      if (result != null) {
        setState((){
          todosState = result.split("`");
        });
      }
    });
  }

  Future getData() async{
    var value = await storage.read(key:"todosState");
    return value;
  }
  
  // methods
  void handleAddTodo(text) {
    setState((){
      todosState.add(text);
    });
    storage.write(key:"todosState", value:todosState.join("`"));
  }

  void saveCheckedValue() {
    print(checkedState.join("`"));
  }



  void handleCheckTap(index) {
    if (!checkedState.contains(index)) {
      setState(()=>checkedState.add(index));
    } else {
      setState(()=>checkedState.remove(index));
    }
    saveCheckedValue();
  }

  void handleDeleteTodo(index) {
    if (index >= 0  && index < todosState.length) {
      setState(()=>todosState.removeAt(index));
      if (checkedState.contains(index)) {
        setState(()=>checkedState.remove(index));
      }
      storage.write(key:"todosState", value:todosState.join("`"));
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
      drawer: Drawer(
        child:ListView(
          children:<Widget>[
            DrawerHeader(
              child: Center(
                child:Text("Simple Todo App",style: TextStyle(color: Colors.white),)
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Material(
              color:Colors.grey,
              child:ListTile(
                leading: Icon(Icons.home, color: Colors.white,),
                title: Text("Home",style:TextStyle(color:Colors.white)),
                onTap:(){
                  Navigator.pop(context);
                }
              ), 
            ),
            Material(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.local_drink),
                title: Text("Test page"),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.of(context).push(SecondPageRoute());
                }
              )
            )
          ]
        )
      ),
      appBar  : AppBar(
        title   : Text(widget.title),
      ),
      body: _currentIndex == 0 ? Center(
        child: todosState.length > 0 ?ListView.separated(
              itemCount   : todosState.length,
              itemBuilder : (context, index) {
                return ListTile(
                  leading   : IconButton(
                    onPressed   : ()=>handleCheckTap(index),
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
      )
      : _pages[_currentIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title:Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check), title:Text("Todos")),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), title:Text("Notes")),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), title:Text("Cash Planner"))
        ]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoForm(func:handleAddTodo)),
            );
        },
        // onPressed : handleAddTodo,
        tooltip   : 'Add to list',
        child     : Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


