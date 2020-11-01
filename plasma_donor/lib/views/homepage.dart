import 'dart:async';

import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plasma_donor/helper/constants.dart';
import 'package:plasma_donor/services/auth.dart';
import 'package:plasma_donor/utils/customWaveIndicator.dart';
import 'package:plasma_donor/views/campaigns.dart';
import 'package:plasma_donor/views/donors.dart';
import 'package:plasma_donor/views/homepagefornews.dart';
import 'package:plasma_donor/views/login_screen.dart';
import 'package:plasma_donor/views/requestBlood.dart';
import 'package:plasma_donor/views/signIn.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  Completer<GoogleMapController> _controller = Completer();
  String _name, _bloodgrp, _email;
  Widget _child;
  AuthService authService = new AuthService();
  signOut() async {
    authService.signOut();
    Constants.saveUserLoggedInSharedPreference(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<Null> _fetchUserInfo() async {
    Map<String, dynamic> _userInfo;
    FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("User Details")
        .document(_currentUser.uid)
        .get();

    _userInfo = _snapshot.data;

    this.setState(() {
      _name = _userInfo['name'];
      _email = _userInfo['email'];
      _bloodgrp = _userInfo['bloodgroup'];
      _child = _myWidget();
    });
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
  void initState() {
    _child = WaveIndicator();
    _loadCurrentUser();
    _fetchUserInfo();
    super.initState();
  }

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
                currentUser == null ? "" : _name,
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
              title: Text("Blood Donors"),
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
              title: Text("Blood Requests"),
              leading: Icon(
                FontAwesomeIcons.burn,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestBlood(112, 121)));
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
              title: Text("Feed"),
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
              title: Text("Logout"),
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.amberAccent[700],
              ),
              onTap: () {
                LoginScreen();
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
                  "https://www.google.com/search?q=single+person+icon+vector&tbm=isch&ved=2ahUKEwiW9d-80N_sAhUIjEsFHYEeBbkQ2-cCegQIABAA&oq=single+person+icon+vector&gs_lcp=CgNpbWcQAzoGCAAQBxAeOggIABAIEAcQHlCfR1iOUmDgU2gAcAB4AIABmgKIAf0JkgEFMC42LjGYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=c8OdX9bvGYiYrtoPgb2UyAs&bih=698&biw=1536&safe=active#imgrc=BDQSbICXyopdRM",
                  22.7196,
                  75.8577,
                  "Mradul Rathore"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://www.google.com/search?q=single+person+icon+vector&tbm=isch&ved=2ahUKEwiW9d-80N_sAhUIjEsFHYEeBbkQ2-cCegQIABAA&oq=single+person+icon+vector&gs_lcp=CgNpbWcQAzoGCAAQBxAeOggIABAIEAcQHlCfR1iOUmDgU2gAcAB4AIABmgKIAf0JkgEFMC42LjGYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=c8OdX9bvGYiYrtoPgb2UyAs&bih=698&biw=1536&safe=active#imgrc=PktHqinZEcRA_M",
                  23.2599,
                  77.4126,
                  "Ritik Jain"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes("assets/illustration3.PNG", 23.1765, 75.7885,
                  "Mahak Mandlecha"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
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
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _makingPhoneCall() async {
    const url = 'tel:9876543210';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendSMS() async {
    String message = "This is a test message!";
    List<String> recipents = ["1234567890", "5556787676"];

    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Widget myDetailsContainer1(String restaurantName) {
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
                fontSize: 24.0,
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
                _makingPhoneCall();
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.amber,
                  size: 40.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _makingPhoneCall();
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _makingPhoneCall();
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _sendSMS();
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.facebookMessenger,
                  color: Colors.amber,
                  size: 40.0,
                ),
              ),
            ),
          ],
        )),
        SizedBox(height: 5.0),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "XYZ colony      \u00B7      2 hours",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(22.7196, 75.8577), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          DewasMarker,
          SagarMarker,
          DasaiMarker,
          IndoreMarker,
          BhopalMarker,
          UjjainMarker
        },
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
}

Marker IndoreMarker = Marker(
  markerId: MarkerId('Indore'), //gramercy
  position: LatLng(22.7196, 75.8577),
  infoWindow: InfoWindow(title: 'Indore'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker BhopalMarker = Marker(
  markerId: MarkerId('Bhopal'),
  position: LatLng(23.2599, 77.4126),
  infoWindow: InfoWindow(title: 'Bhopal'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker UjjainMarker = Marker(
  markerId: MarkerId('Ujjain'),
  position: LatLng(23.1765, 75.7885),
  infoWindow: InfoWindow(title: 'Ujjain'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

//New York Marker

Marker DewasMarker = Marker(
  markerId: MarkerId('Dewas'),
  position: LatLng(22.9676, 76.0534),
  infoWindow: InfoWindow(title: 'Dewas'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker DasaiMarker = Marker(
  markerId: MarkerId('Dasai'),
  position: LatLng(22.7199, 75.1319),
  infoWindow: InfoWindow(title: 'Dasai'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker SagarMarker = Marker(
  markerId: MarkerId('Sagar'),
  position: LatLng(23.8388, 78.7378),
  infoWindow: InfoWindow(title: 'Sagar'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
