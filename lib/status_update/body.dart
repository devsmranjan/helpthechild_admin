import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../components/custom_center.dart';
import '../data_classes/profile_data.dart';

class Body extends StatefulWidget {
  final ProfileData profileData;

  const Body({Key key, @required this.profileData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  int _statusTextColor;
  IconData _statusIcon;

  TextEditingController _detailedStatusEditingController;

  String _lastUpdateDate;

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
    _detailedStatusEditingController =
        TextEditingController(text: widget.profileData.getDetailedStatus);
    _lastUpdateDate =
        widget.profileData.getLastStatusUpdateDateAndTime.split(" ")[0];
  }

  _handelSubmission(String status, BuildContext context) {
    var document =
        Firestore.instance.document('data/${widget.profileData.getID}');
    var now = DateTime.now();

    //Update profile first

    document.updateData({
      'status': status,
      'detailedStatus': _detailedStatusEditingController.text.trim(),
      'lastStatusUpdateDateAndTime': now.toString()
    });

    Firestore.instance
        .document(
            'users/${widget.profileData.getSenderID}/notifications/${now.toString()}')
        .setData({
      'id': now.toString(),
      'dataID': widget.profileData.getID,
      'name': widget.profileData.getName,
      'imgURL': widget.profileData.getImgURL,
      'detailedStatus': _detailedStatusEditingController.text.trim(),
      'time': now
    });

    widget.profileData.setStatus = status;
    widget.profileData.setDetailedStatus =
        _detailedStatusEditingController.text.trim();
    widget.profileData.setLastStatusUpdateDateAndTime = now.toString();

    Navigator.pop(context);

    Flushbar(
      message: "Updating profile...",
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget _onSubmitButton(String title, Color color, var action) {
    return RaisedButton(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      onPressed: action,
      child: Text(
        "$title".toUpperCase(),
        style: TextStyle(letterSpacing: 1.0, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCenter(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      widget.profileData.getName,
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Chip(
                    backgroundColor: Color(_statusTextColor),
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(_statusIcon, color: Colors.white),
                    label: Text(
                      widget.profileData.getStatus.toString().toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            maxLines: 5,
                            controller: _detailedStatusEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Detailed Status"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter detailed status.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          widget.profileData.getStatus == "new"
                              ? _onSubmitButton("review", Color(0xFFDBA716),
                                  () {
                                  _handelSubmission("on review", context);
                                })
                              : widget.profileData.getStatus == "accepted"
                                  ? _onSubmitButton("update", Color(0xFF2196F3),
                                      () {
                                      _handelSubmission("accepted", context);
                                    })
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _onSubmitButton(
                                            "accepted", Color(0xFF16DB3C), () {
                                          _handelSubmission(
                                              "accepted", context);
                                        }),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        _onSubmitButton(
                                            "rejected", Color(0xFFF44336), () {
                                          _handelSubmission(
                                              "rejected", context);
                                        }),
                                      ],
                                    ),
                        ],
                      ))
                ],
              ),
            ),
            widget.profileData.getLastStatusUpdateDateAndTime != ""
                ? Container(
                    child: Text(
                      "Lastly updated on $_lastUpdateDate",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
