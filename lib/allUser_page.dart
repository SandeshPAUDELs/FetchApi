import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'list_resource.dart';

class APICall extends StatefulWidget {
  @override
  _APICallState createState() => _APICallState();
}

class _APICallState extends State<APICall> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double hh = size.height;
    double ww = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('API Call to display data of all users'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: hh * 0.8,
            child: Container(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!['data'] == null) {
                    return Center(
                      child: Text('No data available'),
                    );
                  } else {
                    List<dynamic> users = snapshot.data!['data'];
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                          return ListTile(
                            title: Text('${user['first_name']} ${user['last_name']}'),
                            subtitle: Column(
                              children: [
                                Text('ID: ${user['id']}'),
                                Text('Email: ${user['email']}'),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${user['avatar']}'),
                            ),
                            
                          );
                        
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListResource(),
                  ),
                );
              },
              child: Text('Go to ListResource'),
            ),
          ),
        ],
      ),
    );
  }
}

