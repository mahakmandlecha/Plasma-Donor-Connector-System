import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CampaignList extends StatefulWidget {
  @override
  _CampaignListState createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> {
  bool isPressed = false;
  List<String> title = [];
  List<String> desc = [];
  List<String> path = [];
  FirebaseUser currentUser;

  String _text, _name;

  File _image;
  String _path;

  @override
  void initState() {
    _loadCurrentUser();

    getData();
    super.initState();
  }

  Future<Null> getData() async {
    await Firestore.instance
        .collection('Campaign Details')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          title.add(docs.documents[i].data['name']);
          desc.add(docs.documents[i].data['content']);
          path.add(docs.documents[i].data['image']);
        }
      }
    });
    setState(() {});
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: title.length,
      itemBuilder: (context, index) => 
      Container(
        margin: EdgeInsets.only(left:20.0, right:20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title[index],
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
              ),
            ),
            SizedBox(height: 20.0),
            Flexible(
              fit: FlexFit.loose,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: new Image.network(
                  path[index],
                  height: 400.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                desc[index],
                
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
              thickness: 5.0,
              indent: 30.0,
              endIndent: 30.0,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
