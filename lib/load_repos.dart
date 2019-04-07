import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './globals.dart';

Future<dynamic> getRepos() async {
  dynamic res = await http.get((gitRepo).toString());

  return res.statusCode == 200
      ? json.decode(res.body)
      : throw Exception(res.body);
}

Widget container(Widget child) {
  return Container(
    height: 20.0,
    width: 20.0,
    margin: EdgeInsets.all(10.0),
    child: child,
  );
}

List<Widget> allrepos(repo_list) {
  List<Widget> allrepos_widget = List();
  for (dynamic repo in repo_list) {
    allrepos_widget.add(
      Container(
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
        ),
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
                  var url = repo['html_url'];
                  await canLaunch(url) ? await launch(url) : throw '$url';
                },
              ),
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
                      color: Color(0xFF487BEA),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
                Text(repo['language'].toString()),
                container(
                  Icon(
                    Icons.star,
                    size: 20.0,
                  ),
                ),
                Text(repo['stargazers_count'].toString()),
                container(
                  Icon(
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
                    var url = repo['html_url'].toString();
                    await canLaunch(url) ? await launch(url) : throw '$url';
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
        title: Text("Top Github Repos"),
        backgroundColor: Color(0xFF42A5F5),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getRepos(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Column(
                children: allrepos(snap.data['items']),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
