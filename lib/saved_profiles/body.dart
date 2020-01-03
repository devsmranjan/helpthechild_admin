import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/custom_center.dart';
import '../components/profile_card.dart';
import '../data_classes/user_data.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('dcpu/${userData.id}/saved')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          if (snapshot.data.documents.length <= 0) {
            return CustomCenter(
              child: Text("No data available"),
            );
          }
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CustomCenter(child: CircularProgressIndicator());

          default:
            return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ProfileCard(
                    id: snapshot.data.documents[index].data['dataID'],
                  );
                });
        }
      },
    );
  }
}
