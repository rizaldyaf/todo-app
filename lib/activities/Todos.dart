import 'package:flutter/material.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  List _todos = [0,1];

  @override
  Widget build(BuildContext context){
    return (
      Container(
        child: _todos.length == 0 
          ? Center(
            child: Text("Nothing to do for now, Enjoy the day :)")
          ) 
          : Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child:Text("Lets do this!")
              ),
              // GridView.count(
              //   crossAxisCount: 2,
              //   children: List.generate(5, (index){
              //       return Card(
              //         color: Colors.deepOrange[300],
              //         child: Text("test"),
              //       );
              //   })
              // )
            ],
          )
      )
    );
  }
}
