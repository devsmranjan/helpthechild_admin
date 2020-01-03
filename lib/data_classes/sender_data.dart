class SenderData {
  final String _name;
  final String _email;
  final String _phone;
  final String _photoURL;

  SenderData({String name, String email, String phone, String photoURL})
      : _name = name,
        _email = email,
        _phone = phone,
        _photoURL = photoURL;

  String get getName => _name;
  String get getEmail => _email;
  String get getPhone => _phone;
  String get getPhotoURL => _photoURL;
}
