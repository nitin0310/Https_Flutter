import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()=>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name="";
  Future<List> countries;
  List _items;

  @override
  void initState() {
    countries = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Https requests"),),
        body: FutureBuilder(
                future: countries,
                builder: (BuildContext context,AsyncSnapshot<List> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          title: Text(snapshot.data[index]["name"]),
                        );
                      },
                    ),
                  );
                }
              ),
        ),
    );
  }
  
  Future<List> getData() async {
    print("Get data called");
    var response = await http.get(Uri.encodeFull("https://api.printful.com/countries"));

    List data;
    var extract = json.decode(response.body);
    data = extract["result"];
    setState(() {
      _items=data;
    });
    return data;

  }
}
