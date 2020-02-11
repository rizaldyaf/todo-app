import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "../models/posts.dart";
import "../company/config.dart";

class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute()
      : super(builder: (BuildContext context) => new SecondPage());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SecondPage());
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => new _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Posts> posts = List<Posts>();

  Future<List<Posts>> makeRequest() async{
    final response = await http.get(config["host"]+'/posts');
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)?.map((e) => e == null 
        ? null 
        : Posts.fromJson(e as Map<String, dynamic>))
          ?.toList();
    } else {
      throw Exception ("Gagal memuat data");
    }
    // return response;
  }

  handleClick(){
    makeRequest().then((fetchedPosts){
      setState((){
        posts = fetchedPosts;
      });
    });
  }

  List<Widget> getPosts(List<Posts> posts){
    final List<Widget> postWidgets = <Widget>[];
    if (posts != null) {
      for (int i = 0; i < posts.length; i++) {
        postWidgets.add(new ListTile(
          title: Text(posts[i].title ?? ""),
          subtitle: Text(posts[i].body ?? "")
        ));
      }
    }
    return postWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Second Page'),
        actions: <Widget>[
          FlatButton(
            onPressed: handleClick,
            child: Text("Make Request", style: TextStyle(color:Colors.white),)
          )
        ],
      ),
      body: posts.length > 0 ? ListView(
        children: posts != null ? getPosts(posts).map((postWidget)=>postWidget).toList():<Widget>[]
      ) : Center(child:Text("Tap 'Make request' to load data from the internet"))
    );
  }
}
