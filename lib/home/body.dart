import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/custom_center.dart';
import '../components/profile_card.dart';

import '../data_classes/user_data.dart';

enum FilterOption { all, sent, accepted, onReview, rejected }

class Body extends StatelessWidget {
  final uid;
  final filterOption;

  const Body({Key key, this.uid, @required this.filterOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('data')
          .where('dist', isEqualTo: userData.dist)
          .where('status', isEqualTo: filterOption)
          .orderBy('id', descending: true)
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
                    id: snapshot.data.documents[index].data['id'],
                  );
                });
        }
      },
    );
  }


}
