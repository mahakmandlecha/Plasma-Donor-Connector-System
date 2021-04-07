import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

int _radioval = 0;
int _radioval1 = 0;
int _radioval2 = 0;
int _radioval3 = 0;
int _radioval4 = 0;
int _radioval5 = 0;

class Form1 extends StatefulWidget {
  @override
  _Form1State createState() => _Form1State();
}

class _Form1State extends State<Form1> {
  final picker = ImagePicker();
  String downloadurl;

  File image1;
  File image2;

  var uid = Uuid();
  File imagefile;
  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid.toString());
      final String today = ('$month-$date');

      final file = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      image1 = File(file.path);
      uploadVideo(image1);
    } catch (error) {
      print(error);
    }
  }

  Future<String> uploadVideo(var videofile) async {
    var uuid = new Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");

    await ref.putFile(videofile).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        downloadurl = val;
        // add(downloadurl); //Val here is Already String
        setState(() {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });
                return AlertDialog(
                  content: Text("Uploaded"),
                );
              });
        });
      });
    });
    return downloadurl;
  }

  void _handle(int val) {
    setState(() {
      _radioval = val;
    });
    switch (_radioval) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  void _handle1(int val) {
    setState(() {
      _radioval1 = val;
    });
    switch (_radioval1) {
      case 1:
        break;
      case 0:
        uploadToStorage();
        break;
    }
  }

  void _handle2(int val) {
    setState(() {
      _radioval2 = val;
    });
    switch (_radioval2) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  void _handle3(int val) {
    setState(() {
      _radioval3 = val;
    });
    switch (_radioval3) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  void _handle4(int val) {
    setState(() {
      _radioval4 = val;
    });
    switch (_radioval4) {
      case 0:
        break;
      case 1:
        break;
    }
  }

  void _handle5(int val) {
    setState(() {
      _radioval5 = val;
    });
    switch (_radioval5) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "COVID-19 Consent Form",
          style: TextStyle(
              letterSpacing: 5,
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("Was your COVID-19 diagnosis confirmed by a lab test ?"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval, onChanged: _handle),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval, onChanged: _handle),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Do You have documnetation of the test result ?"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval1, onChanged: _handle1),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval1, onChanged: _handle1),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Do You have any symptoms(Cough,Fever,etc)"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval2, onChanged: _handle2),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval2, onChanged: _handle2),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("I have not travelled to any foreign country in 2020"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval3, onChanged: _handle3),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval3, onChanged: _handle3),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "I am not being in contact with people being infected suspected or diagnosed with COVID-19"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval4, onChanged: _handle4),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval4, onChanged: _handle4),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "If you were tested positive,have you completed 14 days after you became negative"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 0, groupValue: _radioval5, onChanged: _handle5),
                  Text("Yes"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 1, groupValue: _radioval5, onChanged: _handle5),
                  Text("No"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Radio(value: 2, groupValue: _radioval5, onChanged: _handle5),
                  Text("not applicable"),
                ],
              ),
            ),
            Center(
              child: RaisedButton(
                  child: Text("submit"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            content: Text("Fit and Ready to donate",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
