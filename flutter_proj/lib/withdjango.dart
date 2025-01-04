//import 'dart:convert';
// import 'package:djangofl/createpost.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}
class Model {
  late String topic;
  late String body;
  late int id;
  Model({required this.topic, required this.body, required this.id});
  factory Model.fromJson(dynamic json) {
    return Model(
      id: json['id'] as int,
      topic: json['topic'] as String,
      body: json['body'] as String,
    );
  }
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Future<List<Model>> getBlog() async {
      // final response = await http.get(Uri.parse('<http://127.0.0.1:8000/rest>'));
      // if (response.statusCode == 200) {
      //   List<dynamic> apidata = jsonDecode(response.body);
      //   List<Model> modeldata = apidata.map((json) => Model.fromJson(json)).toList();
      //   return modeldata;
      // } else {
      //   throw Exception("Fix: Something went wrong!!");
      // }
      if (4 > 2) {
      List<dynamic> apidata = [
        {"id": 1, "body": "what iskljlk1", "topic": "t1"},
        {"id": 2, "body": "what iskljlk2", "topic": "t2"},
        {"id": 3, "body": "what iskljlk3", "topic": "t3"}
      ];
      List<Model> modeldata = apidata.map((json) => Model.fromJson(json)).toList();
      return modeldata;
    } else {
      throw Exception("Fix: Something went wrong!!");
    }
  }
  late Future<List<Model>> blog;
  @override
  void initState() {
    super.initState();
    blog = getBlog();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Remove debug banner on top of your app
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Add 20px margin on all sides
                  //FutureBuilder builds itself with the latest snapshot of future
                  child: FutureBuilder<List<Model>>(
                    future: blog,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        //Display Progress Indicator as the data loads
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          //create listview that can take an infinite number of data
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                //Align your post topic and body text to the start of the screen
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Topic text styled to be bold
                                  Text(snapshot.data![index].topic,style: TextStyle(fontWeight: FontWeight.bold),),
                                  // Body text with same index or id with topic
                                  // Text(snapshot.data![index].body, ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0), // 30px padding on the left
                                    child: Text(snapshot.data![index].body),
                                  ),
                                  Divider(),
                                ],
                              );
                            });
                          
                      }
                      else {
                        //snapshot exception
                        throw Exception("Could not fetch data");
                      }
                    },
                  ),
                ),
              ),
            ),
            );
  } //build widget
}