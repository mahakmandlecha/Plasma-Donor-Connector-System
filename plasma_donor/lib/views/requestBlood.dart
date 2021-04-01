import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plasma_donor/views/homepage.dart';
//

class RequestBlood extends StatefulWidget {
  double _lat, _lng;
  RequestBlood(this._lat, this._lng);
  @override
  _RequestBloodState createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  final formkey = new GlobalKey<FormState>();
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> _gender = ['Male', 'Female', 'Other'];
  String _selectedGender = '';
  String _selectedBloodGroup = '';
  String _qty;
  String _phone;
  String _address;
  String _name;
  String _age;

  DateTime selectedDate = DateTime.now();
  var formattedDate;
  int flag = 0;
  FirebaseUser currentUser;
  List<Placemark> placemark;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getAddress();
  }

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(_user) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection('Blood Request Details')
          .document(_user['uid'])
          .setData(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        flag = 1;
      });
    var date = DateTime.parse(selectedDate.toString());
    formattedDate = "${date.day}-${date.month}-${date.year}";
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Plasma Request Submitted'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(1000, 221, 46, 68),
                ),
              ),
            ],
          );
        });
  }

  void getAddress() async {
    placemark =
        await Geolocator().placemarkFromCoordinates(widget._lat, widget._lng);
    _address = placemark[0].name.toString() +
        "," +
        placemark[0].locality.toString() +
        "," +
        placemark[0].postalCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Plasma Request",
        ),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.reply, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: 800.0,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: DropdownButton(
                              hint: Text(
                                'Choose a Blood Group',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              iconSize: 40.0,
                              items: _bloodGroup.map((val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedBloodGroup = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _selectedBloodGroup,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.amberAccent[700]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: DropdownButton(
                              hint: Text(
                                'Choose Gender',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              iconSize: 40.0,
                              items: _gender.map((val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _selectedGender,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.amberAccent[700]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Name field can't be empty" : null,
                        onSaved: (value) => _name = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Age',
                          icon: Icon(FontAwesomeIcons.sortNumericDown,
                              color: Colors.amberAccent[700]),
                        ),
                        validator: (value) =>
                            value.length == 0 || value.length > 2
                                ? "Enter valid age"
                                : null,
                        onSaved: (value) => _age = value,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Quantity(units)',
                          icon: Icon(FontAwesomeIcons.prescriptionBottle,
                              color: Colors.amberAccent[700]),
                        ),
                        validator: (value) {
                          int quantity = int.parse(value);
                          if (value.isEmpty) {
                            return "Quantity field can't be empty";
                          } else if (quantity <= 0) {
                            return "Quantity must be greater than zero";
                          } else if (quantity > 9) {
                            return "Quantity must be less than 10 units";
                          }
                          return null;
                        },
                        onSaved: (value) => _qty = value,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Address',
                          icon: Icon(FontAwesomeIcons.addressBook,
                              color: Colors.amberAccent[700]),
                        ),
                        validator: (value) => value.isEmpty
                            ? "Address field can't be empty"
                            : null,
                        onSaved: (value) => _phone = value,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          icon: Icon(FontAwesomeIcons.mobile,
                              color: Colors.amberAccent[700]),
                        ),
                        validator: (value) => value.length != 10
                            ? "Phone Number field can't be empty"
                            : null,
                        onSaved: (value) => _phone = value,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () => _selectDate(context),
                              icon: Icon(FontAwesomeIcons.calendar),
                              color: Colors.amberAccent[700]),
                          flag == 0
                              ? Text(
                                  "<< Pick up a Due Date",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15.0),
                                )
                              : Text(formattedDate),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (!formkey.currentState.validate()) return;
                        formkey.currentState.save();
                        final Map<String, dynamic> BloodRequestDetails = {
                          'uid': currentUser.uid,
                          'name': _name,
                          'bloodGroup': _selectedBloodGroup,
                          'gender': _selectedGender,
                          'quantity': _qty,
                          'dueDate': formattedDate,
                          'phone': _phone,
                          'location': new GeoPoint(widget._lat, widget._lng),
                          'address': _address,
                          'age': _age
                        };
                        addData(BloodRequestDetails).then((result) {
                          dialogTrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.amberAccent[700],
                      child: Text("SUBMIT"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
