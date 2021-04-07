import 'dart:async';

import 'package:plasma_donor/views/faq.dart';
import 'package:plasma_donor/views/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plasma_donor/helper/constants.dart';
import 'package:plasma_donor/services/auth.dart';
import 'package:plasma_donor/utils/customDialogs.dart';
import 'package:plasma_donor/utils/customWaveIndicator.dart';
import 'package:plasma_donor/views/campaigns.dart';
import 'package:plasma_donor/views/patients.dart';
import 'package:plasma_donor/views/homepagefornews.dart';
import 'package:plasma_donor/views/login_screen.dart';

import 'package:plasma_donor/views/requestBlood.dart';

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  Completer<GoogleMapController> _controller = Completer();
  String _name, _bloodgrp, _email, _userSelected;
  Widget _child;
  Position position;

  AuthService authService = new AuthService();

  var lat = [];
  var long = [];
  var city = [];
  var name = [];
  var phone = [];

  Set<Marker> mark = Set();

  signOut() async {
    authService.signOut();
    Constants.saveUserLoggedInSharedPreference(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    _child = WaveIndicator();
    getCurrentLocation();
    _fetchUserInfo();
    _fetchAllOtherUser();
  }

  void _fetchAllOtherUser() async {
    await Firestore.instance
        .collection('Blood Request Details')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          lat.add(docs.documents[i].data['location'].latitude);
          long.add(docs.documents[i].data['location'].longitude);

          city.add(docs.documents[i].data['address']);
          name.add(docs.documents[i].data['name']);
          phone.add(docs.documents[i].data['phone']);
        }
      }
    });
    print(lat);
    print(long);
    print(city);
  }

  Future<Null> _beforeRequestPlacement() async {
    Map<String, dynamic> _userInfo;

    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("Blood Request Details")
        .document(currentUser.uid)
        .get();

    var requestDetails = _snapshot.data;

    print(requestDetails);

    if (requestDetails != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'You already have a request. If you want to place new one, first withdraw old request.'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Okay'),
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RequestBlood(position.latitude, position.longitude)));
    }
  }

  Future<Null> _fetchRequests() async {
    Map<String, dynamic> _userInfo;

    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("Blood Request Details")
        .document(currentUser.uid)
        .get();

    var requestDetails = _snapshot.data;

    print(requestDetails);

    if (requestDetails != null) {
      await Firestore.instance
          .collection("Blood Request Details")
          .document(currentUser.uid)
          .delete();
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "No active plasma request exists.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<Null> _fetchrequestName(requestId) async {
    Map<String, dynamic> _userInfo;
    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("User Details")
        .document(requestId)
        .get();

    _userInfo = _snapshot.data;

    this.setState(() {
      _name = _userInfo['name'];
    });
  }

  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(request['location'].latitude, request['location'].longitude),
        onTap: () async {
          //   CustomDialogs.progressDialog(context: context, message: 'Fetching');
          //   await _fetchrequestName(requestId);
          //   Navigator.pop(context);
          //   return showModalBottomSheet(
          //       backgroundColor: Colors.transparent,
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Container(
          //           margin: const EdgeInsets.all(8.0),
          //           height: 180.0,
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.all(Radius.circular(15)),
          //           ),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: <Widget>[
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: <Widget>[
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: CircleAvatar(
          //                       child: Text(
          //                         request['bloodGroup'],
          //                         style: TextStyle(
          //                           fontSize: 30.0,
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                       radius: 30.0,
          //                       backgroundColor:
          //                           Color.fromARGB(1000, 221, 46, 68),
          //                     ),
          //                   ),
          //                   Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //                       Text(
          //                         _name,
          //                         style: TextStyle(
          //                             fontSize: 18.0, color: Colors.black87),
          //                       ),
          //                       Text(
          //                         "Quantity: " + request['quantity'] + " L",
          //                         style: TextStyle(
          //                             fontSize: 14.0, color: Colors.black87),
          //                       ),
          //                       Text(
          //                         "Due Date: " + request['dueDate'],
          //                         style: TextStyle(
          //                             fontSize: 14.0, color: Colors.red),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          //                 child: Text(
          //                   request['address'],
          //                 ),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: <Widget>[
          //                   RaisedButton(
          //                     onPressed: () {
          //                       UrlLauncher.launch("tel:${request['phone']}");
          //                     },
          //                     textColor: Colors.white,
          //                     padding: EdgeInsets.only(left: 5.0, right: 5.0),
          //                     color: Color.fromARGB(1000, 221, 46, 68),
          //                     child: Icon(Icons.phone),
          //                     shape: new RoundedRectangleBorder(
          //                         borderRadius: new BorderRadius.circular(30.0)),
          //                   ),
          //                   RaisedButton(
          //                     onPressed: () {
          //                       String message =
          //                           "Hello $_name, I am a potential blood donor willing to help you. Reply back if you still need blood.";
          //                       UrlLauncher.launch(
          //                           "sms:${request['phone']}?body=$message");
          //                     },
          //                     textColor: Colors.white,
          //                     padding: EdgeInsets.only(left: 5.0, right: 5.0),
          //                     color: Color.fromARGB(1000, 221, 46, 68),
          //                     child: Icon(Icons.message),
          //                     shape: new RoundedRectangleBorder(
          //                         borderRadius: new BorderRadius.circular(30.0)),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         );
          //       });
          //
        });
    setState(() {
      // adding a new marker to map
      // markers[markerId] = marker;
      print(markerId);
    });
  }

  Future<Null> _fetchUserInfo() async {
    Map<String, dynamic> _userInfo;
    FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
    this.currentUser = _currentUser;
    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("User Details")
        .document(_currentUser.uid)
        // .document(this.currentUser.uid)
        .get();
    print("inside fetchUserInfo" + _currentUser.uid);
    _userInfo = _snapshot.data;

    this.setState(() {
      _name = _userInfo['name'];
      _email = _userInfo['email'];
      _bloodgrp = _userInfo['bloodgroup'];
      _userSelected = _userInfo['user-type'];
      _child = _myWidget();
    });
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    print("ssdfddsfPosition:");
    print(res);
    setState(() {
      position = res;
      // _child = mapWidget();
    });

    print(position.latitude);
    print(position.longitude);
  }

  // Future<void> _loadCurrentUser() async {
  //   await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
  //     setState(() {
  //       // call setState to rebuild the view
  //       print("inside loadCurrentUser"+user.uid);
  //       this.currentUser = user;
  //     });
  //   });
  // }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }

  Widget _myWidget() {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "India",
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amberAccent[700],
              ),
              accountName: Text(
                currentUser == null ? "" : _name + " | " + _userSelected,
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              accountEmail: Text(currentUser == null ? "" : _email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUser == null ? "" : _bloodgrp,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    fontFamily: 'SouthernAire',
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(
                FontAwesomeIcons.home,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text("Patients"),
              leading: Icon(
                FontAwesomeIcons.handshake,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonorsPage()));
              },
            ),
            ListTile(
              title: Text("Request Plasma"),
              leading: Icon(
                FontAwesomeIcons.burn,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                _beforeRequestPlacement();
              },
            ),
            ListTile(
              title: Text("Campaigns"),
              leading: Icon(
                FontAwesomeIcons.ribbon,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CampaignsPage()));
              },
            ),
            ListTile(
              title: Text("Latest News"),
              leading: Icon(
                FontAwesomeIcons.newspaper,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePageForNews()));
              },
            ),
            ListTile(
              title: Text("Withdraw Request"),
              leading: Icon(
                FontAwesomeIcons.trash,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                // withdrawRequest(context);
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Do you want to withdraw request?'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                await _fetchRequests();
                                Navigator.pop(context);
                              }),
                          FlatButton(
                              child: Text('No'),
                              onPressed: () async {
                                Navigator.pop(context);
                              })
                        ],
                      );
                    });
              },
            ),
            ListTile(
              title: Text("FAQ"),
              leading: Icon(
                FontAwesomeIcons.question,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FAQ()));
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(23.2599, 77.4126), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(23.2599, 77.4126), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    if (lat.length > 1) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes(
                    lat?.length > 0 ? lat[0] : 22.735,
                    long?.length > 0 ? long[0] : 22.735,
                    name?.length > 0 ? name[0] : '',
                    phone?.length > 0 ? phone[0] : ''),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes(
                    lat?.length > 0 ? lat[1] : 22.735,
                    long?.length > 0 ? long[1] : 22.735,
                    name?.length > 0 ? name[1] : '',
                    phone?.length > 0 ? phone[1] : ''),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget _boxes(double lat, double long, String restaurantName, String ph) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName, ph),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _sendSMS(num) async {
    String message =
        "Hello! I'm willing to donate plasma. You can contact me on the same number.";

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

  Widget myDetailsContainer1(String restaurantName, String ph) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Colors.amberAccent[700],
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _makingPhoneCall(ph);
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.amber,
                  size: 20.0,
                ),
              ),
            ),
            SizedBox(width: 30.0),
            GestureDetector(
              onTap: () {
                _sendSMS(ph);
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.facebookMessenger,
                  color: Colors.amber,
                  size: 20.0,
                ),
              ),
            ),
          ],
        )),
        // SizedBox(height: 5.0),
        // SizedBox(height: 5.0),
        // Container(
        //     child: Text(
        //   "XYZ colony      \u00B7      2 hours",
        //   style: TextStyle(
        //       color: Colors.black54,
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.bold),
        // )),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    _buildMarker();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(22.7196, 75.8577), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: mark,

        // DewasMarker,
        // SagarMarker,
        // DasaiMarker,
        // IndoreMarker,
        // BhopalMarker,
        // UjjainMarker
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  _buildMarker() {
    for (int i = 0; i < lat.length; ++i) {
      // initMarker(docs.documents[i].data, docs.documents[i].documentID);
      Marker tmp = Marker(
        markerId: MarkerId("$i"),
        position: LatLng(lat[i], long[i]),
        infoWindow: InfoWindow(title: city[i]),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
      );
      print("Marker value");
      print(tmp);
      mark.add(tmp);
    }
    print("outside Marker value");
  }
}

// Marker IndoreMarker = Marker(
//   markerId: MarkerId('Indore'), //gramercy
//   position: LatLng(22.7196, 75.8577),
//   infoWindow: InfoWindow(title: 'Indore'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );

// Marker BhopalMarker = Marker(
//   markerId: MarkerId('Bhopal'),
//   position: LatLng(23.2599, 77.4126),
//   infoWindow: InfoWindow(title: 'Bhopal'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker UjjainMarker = Marker(
//   markerId: MarkerId('Ujjain'),
//   position: LatLng(23.1765, 75.7885),
//   infoWindow: InfoWindow(title: 'Ujjain'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );

// //New York Marker

// Marker DewasMarker = Marker(
//   markerId: MarkerId('Dewas'),
//   position: LatLng(22.9676, 76.0534),
//   infoWindow: InfoWindow(title: 'Dewas'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker DasaiMarker = Marker(
//   markerId: MarkerId('Dasai'),
//   position: LatLng(22.7199, 75.1319),
//   infoWindow: InfoWindow(title: 'Dasai'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
// Marker SagarMarker = Marker(
//   markerId: MarkerId('Sagar'),
//   position: LatLng(23.8388, 78.7378),
//   infoWindow: InfoWindow(title: 'Sagar'),
//   icon: BitmapDescriptor.defaultMarkerWithHue(
//     BitmapDescriptor.hueViolet,
//   ),
// );
