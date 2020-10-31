import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/utils/customDialogs.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth appAuth;
  RegisterPage(this.appAuth);

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  String _name;
  String _address;
  String _phoneNumber;
  String _location;
  var _age;
  List<String> _gender = ['Male', 'Female'];
  String _genderSelected = '';
  List<String> _availability = ['Yes', 'No'];
  String _availabilitySelected = '';
  String _email;
  String _password;
  String _url;
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _BloodGroupSelected = '';
  bool _bloodCategorySelected = false;
  bool _genderCategorySelected = false;
  bool _availabilityCategorySelected = false;
  final formkey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          .collection('User Details')
          .document(_user['uid'])
          .setData(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  bool validate_save() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validate_submit(BuildContext context) async {
    if (validate_save()) {
      try {
        CustomDialogs.progressDialog(
            context: context, message: 'Registration under process');
        FirebaseUser user = (await widget.appAuth
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        Navigator.pop(context);
        print('Registered User: ${user.uid}');
        final Map<String, dynamic> UserDetails = {
          'uid': user.uid,
          'name': _name,
          'address': _address,
          'mobile-no': _phoneNumber,
          'location': _location,
          'email': _email,
          'bloodgroup': _BloodGroupSelected,
          'age': _age,
          'gender': _genderSelected,
          'availability': _availabilitySelected,
        };
        addData(UserDetails).then((result) {
          print("User Added");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }).catchError((e) {
          print(e);
        });
      } catch (e) {
        print('Errr : $e');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Registration Failed'),
                content: Text('Error : $e'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Address'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _address = value;
      },
    );
  }

  Widget _buildMobileNo() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Location'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Location is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _location = value;
      },
    );
  }

  Widget _buildBloodGroup() {
    return Container(
      child: Row(
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
                  _BloodGroupSelected = newValue;
                  this._bloodCategorySelected = true;
                });
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            _BloodGroupSelected,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color.fromARGB(1000, 221, 46, 68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAge() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Age'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Age is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _age = value;
      },
    );
  }

  Widget _buildGender() {
    return Container(
      child: Row(
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
                  _genderSelected = newValue;
                  this._genderCategorySelected = true;
                });
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            _genderSelected,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color.fromARGB(1000, 221, 46, 68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailability() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: DropdownButton(
              hint: Text(
                'Are you available?',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              iconSize: 40.0,
              items: _availability.map((val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _availabilitySelected = newValue;
                  this._availabilityCategorySelected = true;
                });
              },
            ),
          ),
          Text(
            _availabilitySelected,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color.fromARGB(1000, 221, 46, 68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.amberAccent[700],
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildEmail(),
              _buildPassword(),
              _buildAddress(),

              _buildMobileNo(),
              _buildAge(),
              _buildBloodGroup(),
              _buildGender(),
              _buildAvailability(),

              //   _buildPassword(),
              
              RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                    validate_submit(context);
                  _formKey.currentState.save();

                  print(_name);
                  print(_email);
                  print(_phoneNumber);
                  print(_url);
                  print(_password);

                  //Send to API
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
