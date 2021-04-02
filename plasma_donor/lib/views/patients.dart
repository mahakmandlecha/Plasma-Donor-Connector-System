import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plasma_donor/utils/customWaveIndicator.dart';
import 'package:url_launcher/url_launcher.dart';
//

class DonorsPage extends StatefulWidget {
  @override
  _DonorsPageState createState() => _DonorsPageState();
}

class _DonorsPageState extends State<DonorsPage> {
  List<String> patients = [];
  List<String> bloodgroup = [];
  List<String> number = [];
  List<String> gender = [];
  List<String> address = [];
  List<String> age = [];
  Widget _child;

  @override
  void initState() {
    _child = WaveIndicator();
    getDonors();
    super.initState();
  }

  Future<Null> getDonors() async {
    await Firestore.instance
        .collection('Blood Request Details')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          patients.add(docs.documents[i].data['name']);
          bloodgroup.add(docs.documents[i].data['bloodGroup']);
          number.add(docs.documents[i].data['phone']);
          gender.add(docs.documents[i].data['gender']);
          address.add(docs.documents[i].data['address']);
          age.add(docs.documents[i].data['age']);
        }
      }
    });
    setState(() {
      _child = myWidget();
    });
  }

  void _sendSMS(num) async {
    String message = "Hello! I'm willing to donate plasma. You can contact me on the same number.";

    List<String> recipents = [num];
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _makingPhoneCall(num) async {
    var url = "tel:" + num;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget myWidget() {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "India",
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: 800.0,
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100.0,
                  child: Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          bloodgroup[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.amberAccent[700],
                      ),
                      title: Text('${patients[index]} | ${age[index]}'),
                      subtitle: Text(address[index]),
                      trailing: Wrap(spacing: 12, children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            _sendSMS(number[index]);
                          },
                          color: Colors.amberAccent[700],
                        ),                       
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () {
                            _makingPhoneCall(number[index]);
                          },
                          color: Colors.amberAccent[700],
                        ),
                       
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
