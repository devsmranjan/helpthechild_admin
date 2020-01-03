import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_the_child_client/status_update/status_update_screen.dart';
import '../components/custom_center.dart';
import '../data_classes/profile_data_repo.dart';
import '../data_classes/sender_data.dart';
import '../data_classes/profile_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_body.dart';
import '../details/body.dart';
import '../data_classes/user_data.dart';

class Details extends StatefulWidget {
  final id;

  const Details({Key key, @required this.id}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  StreamSubscription<List> _dataSub;
  bool _isSaved = false;
  bool _isLoading = true;
  bool _isSenderDataLoading = true;

  ProfileData _profileData;
  SenderData _senderData;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _getProfileData() async {
    var profile = await ProfileRepository(id: widget.id).getProfileData();

    Firestore.instance.document('data/${widget.id}').get().then((document) {
      _profileData = ProfileData(
          id: profile['id'],
          name: profile['name'],
          imgURL: profile['imgURL'],
          dist: profile['dist'],
          dateOfUpload: profile['dateOfUpload'],
          timeOfUpload: profile['timeOfUpload'],
          status: profile['status'],
          detailedStatus: profile['detailedStatus'],
          address: profile['address'],
          description: profile['description'],
          gender: profile['gender'],
          lastStatusUpdateDateAndTime: profile['lastStatusUpdateDateAndTime'],
          latitude: profile['latitude'],
          longitude: profile['longitude'],
          senderID: profile['senderID']);

      setState(() {
        _isLoading = false;
      });
      _getSenderDetails();
    });
  }

  void _checkSaved() {
    Firestore.instance
        .document('dcpu/${userData.id}/saved/${widget.id}')
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          _isSaved = true;
        });
      } else {
        setState(() {
          _isSaved = false;
        });
      }
    });
  }

  @override
  void initState() {
    _getProfileData();
    _checkSaved();
    super.initState();
  }

  _handelSave() {
    setState(() {
      _isSaved = !_isSaved;
    });

    var savedDocRef =
        Firestore.instance.document('dcpu/${userData.id}/saved/${widget.id}');

    if (_isSaved) {
      savedDocRef
          .setData({'dataID': widget.id, 'id': DateTime.now().toString()});
    } else if (!_isSaved) {
      savedDocRef.delete();
    }
  }

  Future<List> _handelImgDownload() async {
    print("Start share.....");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(),
                    SizedBox(
                      height: 18.0,
                    ),
                    FlatButton(
                      onPressed: _cancelSharing,
                      child: Text("CANCEL"),
                    )
                  ],
                ),
              ),
            ));
    var request = await HttpClient().getUrl(Uri.parse(_profileData.getImgURL));
    print("Request done.....");
    var response = await request.close();
    print("Response done.....");
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    print("bytes done.....");

    return bytes;
  }

  void _handelShare() {
    String _shareText = "Here I am sharing a child details below.\n\n" +
        "Child name: ${_profileData.getName}.\nDate and time: ${_profileData.getDateOfUpload} at ${_profileData.getTimeOfUpload}.\nGender: ${_profileData.getGender}.\nAddress: ${_profileData.getAddress}.\nDescription: ${_profileData.getDescription}.\nClick here for the location: https://www.google.com/maps/search/?api=1&query=${_profileData.getLatitude},${_profileData.getLongitude}.\n\nSender's details:\nName: ${_senderData.getName}.\nPhone: ${_senderData.getPhone}.\nEmail: ${_senderData.getEmail}. ";

    _dataSub = _handelImgDownload().asStream().listen((List data) async {
      print("entered in stream sharing.....");
      await Share.file(_profileData.getName, '${_profileData.getName}.jpg',
          data, 'image/jpg',
          text: _shareText);

      Navigator.pop(context);
    });
  }

  void _cancelSharing() {
    Navigator.pop(context);
    _dataSub.cancel();
  }

  Future<void> _handelMap() async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${_profileData.getLatitude},${_profileData.getLongitude}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Flushbar(
        message: "Could not open the map.",
        duration: Duration(seconds: 3),
      )..show(context);
      throw 'Could not open the map.';
    }
  }

  Future<void> _getSenderDetails() async {
    print(_profileData.getSenderID);
    Firestore.instance
        .document('users/${_profileData.getSenderID}')
        .get()
        .then((document) {
      _senderData = SenderData(
          name: document.data['name'],
          email: document.data['email'],
          phone: document.data['phone'],
          photoURL: document.data['photoURL']);

      setState(() {
        _isSenderDataLoading = false;
      });
    });
  }

  _showSenderDetails() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(_senderData.getPhotoURL),
                        radius: 28.0,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        _senderData.getName,
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _senderData.getPhone != ""
                              ? OutlineButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    launch("tel:${_senderData.getPhone}");
                                  },
                                  child: Icon(Icons.call),
                                  // elevation: 0.0,
                                )
                              : Container(),
                          _senderData.getPhone != ""
                              ? SizedBox(
                                  width: 8.0,
                                )
                              : Container(),
                          OutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                              launch("mailto:${_senderData.getEmail}");
                            },
                            child: Icon(Icons.mail),
                            // elevation: 0.0,
                          ),
                        ],
                      )
                    ],
                  )),
            ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: FabCircularMenu(
          ringColor: Theme.of(context).primaryColor,
          ringDiameter: 300.0,
          fabColor: Theme.of(context).accentColor,
          fabOpenIcon: Icon(
            FontAwesomeIcons.th,
            size: 20.0,
          ),
          fabCloseIcon: Icon(
            FontAwesomeIcons.times,
            size: 20.0,
          ),
          animationDuration: Duration(milliseconds: 500),
          options: <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.userAlt),
                tooltip: "Sender's details",
                onPressed: !_isSenderDataLoading ? _showSenderDetails : null),
            
            !_isLoading && _profileData.getStatus != "rejected"
                    ? IconButton(
                        icon: Icon(FontAwesomeIcons.solidEdit),
                        tooltip: "Edit status",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatusUpdate(
                                        profileData: _profileData,
                                      ),
                                  fullscreenDialog: true));
                        }): Container(),
                
            IconButton(
                icon: Icon(FontAwesomeIcons.mapMarkedAlt),
                tooltip: "Map",
                onPressed: !_isLoading ? _handelMap : null),
          ],
          child: CustomBody(
              appBarTitle: Container(),
              appBarTitleAfterScroll: !_isLoading
                  ? Text(_profileData.getName,
                      style: GoogleFonts.patuaOne()
                          .copyWith(color: Colors.black87))
                  : Text(""),
              appBarLeading: IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft,
                    color: Colors.black87, size: 20.0),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              appBarActions: !_isLoading
                  ? <Widget>[
                      IconButton(
                        tooltip: "Share",
                        icon: Icon(FontAwesomeIcons.share,
                            color: Colors.black87, size: 20.0),
                        onPressed: _handelShare,
                      ),
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('dcpu/${userData.id}/saved')
                            .where('dataID', isEqualTo: widget.id)
                            .limit(1)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data.documents.length >= 1) {
                            return IconButton(
                              tooltip: "Save",
                              icon: Icon(FontAwesomeIcons.solidBookmark,
                                  color: Colors.black87, size: 20.0),
                              onPressed: _handelSave,
                            );
                          }

                          return IconButton(
                            tooltip: "Save",
                            icon: Icon(FontAwesomeIcons.bookmark,
                                color: Colors.black87, size: 20.0),
                            onPressed: _handelSave,
                          );
                        },
                      ),
                    ]
                  : [],
              body: !_isLoading
                  ? Body(profileData: _profileData)
                  : CustomCenter(
                      child: CircularProgressIndicator(),
                    )),
        ));
  }
}
