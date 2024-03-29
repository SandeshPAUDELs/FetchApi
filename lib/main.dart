import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'allUser_page.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

// String stringResponse;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Map<String, dynamic> StringResponse;
  Future<void> apicall() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('https://reqres.in/api/users/2'));
      if (response.statusCode == 200) {
        // setState(() {
        //   stringResponse = response.body;
        // });
        StringResponse = json.decode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double hh = size.height;
    double ww = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("API"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: hh * 0.8,
            width: ww * 0.8,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
              future: apicall(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  String name = StringResponse['data']['first_name'];
                  String name1 = StringResponse['data']['last_name'];
                  String email = StringResponse['data']['email'];
                  String avatar = StringResponse['data']['avatar'];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(child: Text('My name is $name $name1')),
                        SizedBox(child: Text('My email is $email')),
                        SizedBox(child: Image.network(avatar)),
                        SizedBox(height: hh * 0.5),
                        SizedBox(
                          child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => APICall(),
                              ),
                            );
                          },
                          child: Text("Click to go to next page"),
                                                ),
                        ),],
                    ),
                  );
                }
              },
            ),
          ),
          
        ),
        
      ),
    );
  }
}
