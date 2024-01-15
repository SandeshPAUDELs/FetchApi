import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final String apiUrl = "https://reqres.in/api/users";
  List<Map<String, dynamic>> createdUsers = [];

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/unknown/2'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createUser() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': 'morpheus',
          'job': 'leader',
        }),
      );

      if (response.statusCode == 201) {
        print("User created successfully!");
        print("Response: ${response.body}");

        // Parse and add the created user details to the list
        setState(() {
          createdUsers.add(json.decode(response.body));
        });

        // You can add logic here to refresh the data if needed
        // For example, you can call fetchData() again and update the UI
      } else {
        print("Failed to create user. Status code: ${response.statusCode}");
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  void deleteUser(int index) {
    setState(() {
      createdUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double hh = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('API Call to create and display users'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: hh * 0.8,
            child: Container(
              child: createdUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: createdUsers.length,
                      itemBuilder: (context, index) {
                        var user = createdUsers[index];
                        return Dismissible(
                          key: Key(user['id'].toString()),
                          onDismissed: (direction) {
                            deleteUser(index);
                          },
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 36.0,
                                ),
                              ),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          child: ListTile(
                            title: Text('User ${index + 1} - ${user['name']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${user['id']}'),
                                Text('Job: ${user['job']}'),
                                Text('Created At: ${user['createdAt']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : FutureBuilder<Map<String, dynamic>>(
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
                        } else if (!snapshot.hasData ||
                            snapshot.data!['data'] == null) {
                          return Center(
                            child: Text('No data available'),
                          );
                        } else {
                          var user = snapshot.data!['data'];
                          return ListTile(
                            title: Text('${user['name']}'),
                            subtitle: Column(
                              children: [
                                Text('ID: ${user['id']}'),
                                Text('Year: ${user['year']}'),
                                Text('Color: ${user['color']}'),
                                Text('Pantone Value: ${user['pantone_value']}'),
                              ],
                            ),
                          );
                        }
                      },
                    ),
            ),
          ),
          SizedBox(
            height: hh * 0.02,
            child: ElevatedButton(
              onPressed: () {
                // Call the createUser function directly when the button is pressed
                createUser();
              },
              child: Text('Create User'),
            ),
          ),
        ],
      ),
    );
  }
}
