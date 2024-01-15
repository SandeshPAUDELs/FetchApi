import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'create_user.dart';

class SingleResource extends StatefulWidget {
  @override
  _SingleResourceState createState() => _SingleResourceState();
}

class _SingleResourceState extends State<SingleResource> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/unknown/2'));

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
        title: Text('API Call to display data of single user'),
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
          SizedBox(height: hh * 0.02,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateUser()));
            },
            child: Text('Go to another page nto create user'),
          ),
          ),
        ],
      ),
    );
  }
}