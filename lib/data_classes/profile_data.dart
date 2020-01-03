import 'package:flutter/foundation.dart';

class ProfileData {
  final String _id;
  final String _name;
  final String _imgURL;
  final String _dist;
  final String _dateOfUpload;
  final String _timeOfUpload;
  String _status;
  String _detailedStatus;
  final String _address;
  final String _description;
  final String _gender;
  String _lastStatusUpdateDateAndTime;
  final String _latitude;
  final String _longitude;
  final String _senderID;

  ProfileData(
      {@required String id,
      @required String name,
      @required String imgURL,
      @required String dist,
      @required String dateOfUpload,
      @required String timeOfUpload,
      @required String status,
      @required String detailedStatus,
      @required String address,
      @required String description,
      @required String gender,
      @required String lastStatusUpdateDateAndTime,
      @required String latitude,
      @required String longitude,
      @required String senderID})
      : _id = id,
        _name = name,
        _imgURL = imgURL,
        _dist = dist,
        _dateOfUpload = dateOfUpload,
        _timeOfUpload = timeOfUpload,
        _status = status,
        _detailedStatus = detailedStatus,
        _address = address,
        _description = description,
        _gender = gender,
        _lastStatusUpdateDateAndTime = lastStatusUpdateDateAndTime,
        _latitude = latitude,
        _longitude = longitude,
        _senderID = senderID;

  String get getID => _id;
  String get getName => _name;
  String get getImgURL => _imgURL;
  String get getDist => _dist;
  String get getDateOfUpload => _dateOfUpload;
  String get getTimeOfUpload => _timeOfUpload;
  String get getStatus => _status;
  String get getDetailedStatus => _detailedStatus;
  String get getAddress => _address;
  String get getDescription => _description;
  String get getGender => _gender;
  String get getLastStatusUpdateDateAndTime => _lastStatusUpdateDateAndTime;
  String get getLatitude => _latitude;
  String get getLongitude => _longitude;
  String get getSenderID => _senderID;


  set setStatus(String status) {
    _status = status;
  }
  set setDetailedStatus(String detailedStatus) {
    _detailedStatus = _detailedStatus;
  }
  set setLastStatusUpdateDateAndTime(String lastStatusUpdateDateAndTime) {
    _lastStatusUpdateDateAndTime = lastStatusUpdateDateAndTime;
  }
}
