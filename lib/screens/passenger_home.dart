import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_reg_002/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login_screen.dart';

class Passenger extends StatefulWidget {
  const Passenger({super.key});

  @override
  State<Passenger> createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {

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
        title: Text("Passenger"),
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
                "Welcome Back ${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 180,
                child: Image.asset("assets/mob_logo.jpg", fit: BoxFit.contain),
              ),
              QrImage(data: "${loggedInUser.nic}"),
              // user can create his own QR code
              SizedBox(height: 1.0,),
              SizedBox(
                height: 20.0,
              ),
              // Text("${loggedInUser.email}",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //     )),
              // Text("${loggedInUser.nic}",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //     )),
              SizedBox(
                height: 18,
              ),
              ActionChip(
                  label: Text("Logout",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )),

                  onPressed: () {
                    logout(context);
                  }),
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
}
