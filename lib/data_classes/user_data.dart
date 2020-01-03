class UserData {
  static final UserData _userData = UserData._internal();
  String id;
  String dcpo;
  String dist;
  String address;
  String email;
  String officeTelephoneNo; 
  String residenceTelephoneNo;
  String state;

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();