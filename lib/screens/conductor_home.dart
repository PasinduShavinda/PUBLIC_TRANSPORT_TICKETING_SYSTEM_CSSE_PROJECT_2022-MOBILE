import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_reg_002/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';

class Conductor extends StatefulWidget {
  const Conductor({super.key});

  @override
  State<Conductor> createState() => _ConductorState();
}

class _ConductorState extends State<Conductor> {

  final CollectionReference _trips =
  FirebaseFirestore.instance.collection('passengerTrips');

  String qrResult = "Not Yet Scanned";
  String locationStart ='Press Button';
  String locationEnd = 'Press Button';
  String AddressStart = 'search';
  String AddressEnd = 'search';

  double dist = 0.0;
  double dist2 = 0.0;
  double endLt = 0.0;
  double endLn = 0.0;
  double startLt = 0.0;
  double startLn = 0.0;
  double tripFare = 0.0;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conductor"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome ${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: Image.asset("assets/mob_logo.jpg", fit: BoxFit.contain),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Passenger NIC",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                qrResult, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                  child:Text("SCAN QR CODE"),
                  onPressed:() async{
                    String scanning = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
                    setState(() {
                      qrResult = scanning;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.red, width: 2.0)
                          )
                      )
                  )
              ),

              ElevatedButton(onPressed: () async{
                Position position = await _getGeoLocationPositionStart();
                locationStart ='Lat: ${position.latitude} , Long: ${position.longitude}';

                // startLt = position.latitude;
                // startLn = position.longitude;

                startLt = 44.968046;
                startLn = -94.420307;

                GetStartAddressFromLatLong(position);
              }, child: Text('Get Start Location'
              )
              ),

                Text('Start Location',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(locationStart,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('ADDRESS : ${AddressStart}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height:17,
                ),
                // Text('${Address}'),

                ElevatedButton(onPressed: () async{
                  Position position = await _getGeoLocationPositionEnd();
                  locationEnd ='Lat: ${position.latitude} , Long: ${position.longitude}';

                  // endLt = position.latitude;
                  // endLn = position.longitude;

                  endLt = 44.33328;
                  endLn = -89.132008;

                  GetEndAddressFromLatLong(position);
                  GetDistance(startLt, startLn, endLt, endLn);
                  calTripFare();
                }, child: Text(
                    'Get End Location'
                )
                ),

              Text(
                'End Location',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                locationEnd,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'ADDRESS: ${AddressEnd}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Distance : ' + dist.toStringAsFixed(2) + " KM",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Trip Fare : ' + tripFare.toStringAsFixed(2) + " LKR",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  child:Text("SAVE"),
                  onPressed: () async {
                    final String nic = qrResult;
                    final String startLoc =  locationStart;
                    final String startLocAdd = AddressStart;
                    final String endLoc = locationEnd;
                    final String endLocAdd = AddressEnd;
                    final double? trpDist = dist;
                    final double? trpFare = tripFare;

                    if (nic != null) {
                      await _trips.add({
                        "passengerNic": nic,
                        "startLocation": startLoc,
                        "startLocationAddress": startLocAdd,
                        "endLocation": endLoc,
                        "endLocationAddress": endLocAdd,
                        "tripDistance": trpDist,
                        "tripFare": trpFare
                      });
                      Fluttertoast.showToast(msg: "Trip Details Saved Successfully :) ");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conductor(),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.red, width: 2.0)
                          )
                      )
                  )
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<Position> _getGeoLocationPositionStart() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position> _getGeoLocationPositionEnd() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

    Future<void> GetStartAddressFromLatLong(Position position)async {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      AddressStart = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(()  {
      });
    }
    Future<void> GetEndAddressFromLatLong(Position position)async {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      AddressEnd = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(()  {
      });
    }
      // Calculate the distance between locations
      GetDistance(double startLat1, double endLon1, double startLat2, double endLon2) async{
      //dist = await Geolocator.distanceBetween(startLat1, endLon1, startLat2, endLon2);
        var p = 0.017453292519943295;
        var a = 0.5 - cos((startLat2 - startLat1) * p)/2 +
            cos(startLat1 * p) * cos(startLat2 * p) *
                (1 - cos((endLon2 - endLon1) * p))/2;
        dist = 12742 * asin(sqrt(a));
        setState(()  {
        });
  }
      // Calculate the TRIP FARE
      calTripFare(){
        var chargePerKm = 50.00;
        tripFare = chargePerKm * dist;
        setState(()  {
        });
      }


  // Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
  //
  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return Padding(
  //           padding: EdgeInsets.only(
  //               top: 20,
  //               left: 20,
  //               right: 20,
  //               bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               TextField(
  //                 controller: _passengerNameController,
  //                 decoration: const InputDecoration(labelText: 'Passenger Name'),
  //               ),
  //               TextField(
  //                 controller: _passengerNicController,
  //                 decoration: const InputDecoration(labelText: 'NIC'),
  //               ),
  //               TextField(
  //                 controller: _startLocationController,
  //                 decoration: const InputDecoration(labelText: 'Start Location'),
  //               ),
  //               TextField(
  //                 controller: _startLocationAddressController,
  //                 decoration: const InputDecoration(labelText: 'Start Address'),
  //               ),
  //               TextField(
  //                 controller: _endLocationController,
  //                 decoration: const InputDecoration(labelText: 'End Location'),
  //               ),
  //               TextField(
  //                 controller: _endLocationAddressController,
  //                 decoration: const InputDecoration(labelText: 'End Location Address'),
  //               ),
  //               TextField(
  //                 controller: _tripDistanceController,
  //                 decoration: const InputDecoration(labelText: 'Trip Distance'),
  //               ),
  //               TextField(
  //                 controller: _tripFareController,
  //                 decoration: const InputDecoration(labelText: 'Trip Fare'),
  //               ),
  //               // TextField(
  //               //   keyboardType:
  //               //   const TextInputType.numberWithOptions(decimal: true),
  //               //   controller: _priceController,
  //               //   decoration: const InputDecoration(
  //               //     labelText: 'Price',
  //               //   ),
  //               // ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               ElevatedButton(
  //                 child: const Text('Create'),
  //                 onPressed: () async {
  //                   final String passengerName = "Amal";
  //                   final String nic = "200909098765";
  //                   final String startLoc =  "startloc";
  //                   final String startLocAdd = "5th Lane Colombo";
  //                   final String endLoc = "endloc";
  //                   final String endLocAdd = "8th Lane, Nugegoda";
  //                   final double? trpDist = 7383.00;
  //                   final double? tripFare = 5020.00;
  //
  //                   if (nic != null) {
  //                     await _trips.add({"passengerName": passengerName,
  //                                       "passengerNic": nic,
  //                                       "startLocation": startLoc,
  //                                       "startLocationAddress": startLocAdd,
  //                                       "endLocation": endLoc,
  //                                       "endLocationAddress": endLocAdd,
  //                                       "tripDistance": trpDist,
  //                                       "tripFare": tripFare
  //                     });
  //                     _passengerNameController.text = '';
  //                     _passengerNicController.text = '';
  //                     _startLocationController.text = '';
  //                     _startLocationAddressController.text = '';
  //                     _endLocationController.text = '';
  //                     _endLocationAddressController.text = '';
  //                     _tripDistanceController.text = '';
  //                     _tripFareController.text = '';
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //
  //       });
  // }
      // postTripDetailsToFirestore() async {
      //   // calling our firestore
      //   // calling our user model
      //   // sedning these values
      //
      //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      //   User? user = _auth.currentUser;
      //
      //   TripModel tripModel = TripModel();
      //
      //   // writing all the values
      //   tripModel.uid = user?.uid;
      //   tripModel.passengerName = "Passenger";
      //   tripModel.passengerNic = qrResult;
      //   tripModel.startLocation = locationStart;
      //   tripModel.startLocationAddress = AddressStart;
      //   tripModel.endLocation = locationEnd;
      //   tripModel.endLocationAddress = AddressEnd;
      //   tripModel.tripDistance = dist;
      //   tripModel.tripFare = tripFare;
      //
      //   await firebaseFirestore
      //       .collection("passengerTrips")
      //       .doc(user?.uid)
      //       .set(tripModel.toMap());
      //   Fluttertoast.showToast(msg: "Successfully Saved :) ");
      //
      //   Navigator.pushAndRemoveUntil(
      //       (context),
      //       MaterialPageRoute(builder: (context) => Conductor()),
      //           (route) => false);
      // }

  // void saveTripDetails(String email, String password) async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await _auth
  //           .createUserWithEmailAndPassword(email: email, password: password)
  //           .then((value) => {postDetailsToFirestore()})
  //           .catchError((e) {
  //         Fluttertoast.showToast(msg: e!.message);
  //       });
  //     } on FirebaseAuthException catch (error) {
  //       switch (error.code) {
  //         case "invalid-email":
  //           errorMessage = "Your email address appears to be malformed.";
  //           break;
  //         case "wrong-password":
  //           errorMessage = "Your password is wrong.";
  //           break;
  //         case "user-not-found":
  //           errorMessage = "User with this email doesn't exist.";
  //           break;
  //         case "user-disabled":
  //           errorMessage = "User with this email has been disabled.";
  //           break;
  //         case "too-many-requests":
  //           errorMessage = "Too many requests";
  //           break;
  //         case "operation-not-allowed":
  //           errorMessage = "Signing in with Email and Password is not enabled.";
  //           break;
  //         default:
  //           errorMessage = "An undefined Error happened.";
  //       }
  //       Fluttertoast.showToast(msg: errorMessage!);
  //       print(error.code);
  //     }
  //   }
  // }

}

