import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data_classes/profile_data.dart';
import '../fullscreen/fullscreen_screen.dart';

class Body extends StatefulWidget {
  final ProfileData profileData;

  const Body({Key key, @required this.profileData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _statusTextColor;
  IconData _statusIcon;
  final TextStyle _headingTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500);
  final TextStyle _bodyTextStyle = TextStyle(
    color: Color(0xFF757575),
  );

  _getStatusColorAndIcon(String status) {
    switch (status.toLowerCase()) {
      case "new":
        _statusTextColor = 0xFF2196F3;
        _statusIcon = Icons.new_releases;
        break;
      case "on review":
        _statusTextColor = 0xFFDBA716;
        _statusIcon = Icons.query_builder;
        break;
      case "accepted":
        _statusTextColor = 0xFF16DB3C;
        _statusIcon = Icons.check_circle;
        break;
      case "rejected":
        _statusTextColor = 0xFFF44336;
        _statusIcon = Icons.info;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getStatusColorAndIcon(widget.profileData.getStatus);
  }

  Widget _statusContainer() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('data')
          .where('id', isEqualTo: widget.profileData.getID)
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var status;

        if (snapshot.hasData && snapshot.data.documents.length >= 1) {
          status = snapshot.data.documents[0].data['status'];
          if(status == "sent") {
            status = "new";
          }
          if (status != null) {
            _getStatusColorAndIcon(status.toString());
          }
          return FloatingActionButton.extended(
            heroTag: '',
            onPressed: null,
            icon: Icon(
              _statusIcon,
              color: Color(_statusTextColor),
            ),
            label: Text(
              status.toString().toUpperCase(),
              style: TextStyle(color: Color(_statusTextColor)),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
          );
        }

        return Container();
      },
    );
  }

  Widget _detailedStatusBar() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('data')
            .where('id', isEqualTo: widget.profileData.getID)
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var detailedStatus;
          var status;

          if (snapshot.hasData && snapshot.data.documents.length >= 1) {
            status = snapshot.data.documents[0].data['status'];
            detailedStatus = snapshot.data.documents[0].data['detailedStatus'];
            if (status != null) {
              _getStatusColorAndIcon(status.toString());
            }
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 18.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Color(_statusTextColor)),
            child: Text(
              detailedStatus != null ? detailedStatus : "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  Widget _otherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Date & Time of upload",
          style: _headingTextStyle,
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          "${widget.profileData.getDateOfUpload} at ${widget.profileData.getTimeOfUpload}",
          style: _bodyTextStyle,
        ),
        SizedBox(
          height: 14.0,
        ),
        Text(
          "Address",
          style: _headingTextStyle,
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          "${widget.profileData.getAddress}",
          style: _bodyTextStyle,
        ),
        SizedBox(
          height: 14.0,
        ),
        Text(
          "Gender",
          style: _headingTextStyle,
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          widget.profileData.getGender.toUpperCase(),
          style: _bodyTextStyle,
        ),
        SizedBox(
          height: 14.0,
        ),
        Text(
          "Description",
          style: _headingTextStyle,
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          widget.profileData.getDescription != ""
              ? widget.profileData.getDescription
              : "NA",
          style: _bodyTextStyle,
        ),
        SizedBox(
          height: 42.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 14.0,
            ),
            Center(
              child: Text(
                widget.profileData.getName,
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Fullscreen(
                                  name: widget.profileData.getName,
                                  imgURL: widget.profileData.getImgURL,
                                ),
                            fullscreenDialog: true));
                  },
                  child: Container(
                    height: 200.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                        tag: "child photo",
                        child: CachedNetworkImage(
                          imageUrl: widget.profileData.getImgURL,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Center(child: Text(error)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 250.0,
                ),
                Positioned(
                    bottom: 24,
                    left: 0.0,
                    right: 0.0,
                    child: Center(child: _statusContainer()))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _detailedStatusBar(),
                SizedBox(
                  height: 28.0,
                ),
                _otherDetails(),
                SizedBox(
                  height: 18.0,
                ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
