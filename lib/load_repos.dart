import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './globals.dart';

Future<dynamic> getRepos() async {
  final url = (gitRepo).toString();

  dynamic response = await http.get(url);

  if (response.statusCode == 200) {
    dynamic responseJson = json.decode(response.body);
    // print(responseJson);
    return responseJson;
  } else {
    throw Exception(response.body);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

List<Widget> allrepos(repo_list) {
  // print(repo_list);
  List<Widget> allrepos_widget = List();
  for (dynamic repo in repo_list) {
    allrepos_widget.add(
      Container(
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                  child: Text(
                    repo['name'].toString(),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue),
                  ),
                  onTap: () async {
                    var url = repo['html_url'].toString();
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
            ),
            Text(repo['description'].toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20.0,
                  width: 20.0,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: langColors[repo['language'].toString()] != null
                          ? HexColor(langColors[repo['language'].toString()]
                              .toString())
                          : Colors.yellow,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
                Text(repo['language'].toString()),
                Container(
                  height: 20.0,
                  width: 20.0,
                  margin: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.star,
                    size: 20.0,
                  ),
                ),
                Text(repo['watchers'].toString()),
                Container(
                  height: 20.0,
                  width: 20.0,
                  margin: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.merge_type,
                    size: 15.0,
                  ),
                ),
                Text(repo['forks_count'].toString()),
                Container(
                  margin: EdgeInsets.only(left: 40.0, right: 10.0),
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Image.network(repo['owner']['avatar_url'].toString()),
                ),
                GestureDetector(
                  child: Text(
                    repo['owner']['login'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    var url = repo['owner']['html_url'].toString();
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
  return allrepos_widget;
}

class ShowRepo extends StatefulWidget {
  ShowRepo({Key key}) : super(key: key);
  @override
  _ShowRepoState createState() => _ShowRepoState();
}

class _ShowRepoState extends State<ShowRepo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending Github Repos"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Language       ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton(
                  items: [
                    DropdownMenuItem(
                      child: Text("First Option"),
                    ),
                    DropdownMenuItem(
                      child: Text("Second Option"),
                    ),
                    DropdownMenuItem(
                      child: Text("Third Option"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            FutureBuilder(
              future: getRepos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: allrepos(snapshot.data['items']),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
