import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  final String _id;

  ProfileRepository({@required String id}) : _id = id;

  Future<Map<String, dynamic>> getProfileData() async {
    DocumentSnapshot document =
        await Firestore.instance.document('data/$_id').get();

    return {
      "id": _id,
      "name": document.data['name'] ?? "",
      "imgURL": document.data['imgURL'] ?? "",
      "dist": document.data['dist'] ?? "",
      "dateOfUpload": document.data['dateOfUpload'] ?? "",
      "timeOfUpload": document.data['timeOfUpload'] ?? "",
      "status": document.data['status'] == "sent" ? "new" : document.data['status'] ?? "",
      "detailedStatus": document.data['detailedStatus'] ?? "",
      "address":
          "${document.data['streetAddress']}, ${document.data['dist']}, ${document.data['state']} ${document.data['pin']}" ?? "",
      "description": document.data['description'] ?? "",
      "gender": document.data['gender'] ?? "",
      "lastStatusUpdateDateAndTime":
          document.data['lastStatusUpdateDateAndTime'] ?? "",
      "latitude": document.data['latitude'] ?? "",
      "longitude": document.data['longitude'] ?? "",
      "senderID": document.data['userID'] ?? ""
    };
  }
}
