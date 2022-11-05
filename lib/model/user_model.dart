class UserModel {
  String? uid;
  String? email;
  String? nic;
  String? firstName;
  String? secondName;
  String? userType;

  UserModel({this.uid, this.email,this.nic, this.firstName, this.secondName, this.userType});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nic: map['nic'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      userType: map['userType'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nic': nic,
      'firstName': firstName,
      'secondName': secondName,
      'userType': userType,
    };
  }
}
