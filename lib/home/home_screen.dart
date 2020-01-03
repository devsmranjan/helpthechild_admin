import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../analysis/analysis_screen.dart';
import '../components/custom_body.dart';
import '../components/custom_center.dart';
import '../home/logout_tile.dart';
import '../saved_profiles/saved_profiles_screen.dart';
import '../user_repo/user_repository.dart';

import '../data_classes/user_data.dart';
import 'body.dart';
import 'logout/bloc/logout_bloc.dart';

class Home extends StatefulWidget {
  final _uid;
  final UserRepository _userRepository;

  Home({Key key, @required UserRepository userRepository, @required uid})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _uid = uid,
        super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  LogoutBloc _logoutBloc;
  UserRepository get _userRepository => widget._userRepository;

  FilterOption _filterOption = FilterOption.all;

  bool _isLoading = true;

  Future<void> _getUserData() {
    DocumentReference _docRefForUserProfile =
        Firestore.instance.document('dcpu/${widget._uid}');

    return _docRefForUserProfile.get().then((document) {
      // user Data
      userData.id = document['id'];
      userData.address = document['address'];
      userData.dcpo = document['dcpo'];
      userData.email = document['email'];
      userData.officeTelephoneNo = document['officeTelephoneNo'];
      userData.residenceTelephoneNo = document['residenceTelephoneNo'];
      userData.dist = document['dist'];
      userData.state = document['state'];
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _logoutBloc = LogoutBloc(
      userRepository: _userRepository,
    );
    _getUserData();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
              child: !_isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'Profile Photo',
                          child: CircleAvatar(
                            radius: 32,
                            child: Text(
                              userData.dcpo[0],
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        FittedBox(
                          child: Text(
                            userData.dcpo,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        FittedBox(
                          child: Text(
                            userData.email,
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xFF707070)),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
          ListTile(
            leading: Icon(Icons.collections_bookmark),
            title: Text('Saved profiles'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavedProfiles()));
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Analysis'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Analysis()));
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share this App'),
            onTap: () async {
              Navigator.pop(context);
              final ByteData bytes =
                  await rootBundle.load('assets/logo/logo_square.png');
              await Share.file('Help the child', 'helpthechild.png',
                  bytes.buffer.asUint8List(), 'image/png',
                  text:
                      'Download Help the child app from here https://smrutiranjanrana.github.io to accept children\'s data from your dist.');
            },
          ),
          LogoutTile()
        ],
      ),
    );
  }

  void _buildBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(4.0),
                    topRight: const Radius.circular(4.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 24.0,
                  height: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                RadioListTile<FilterOption>(
                  title: const Text('All'),
                  value: FilterOption.all,
                  groupValue: _filterOption,
                  onChanged: (FilterOption value) {
                    Navigator.pop(context);
                    setState(() {
                      _filterOption = value;
                    });
                  },
                ),
                RadioListTile<FilterOption>(
                  title: const Text('Sent'),
                  value: FilterOption.sent,
                  groupValue: _filterOption,
                  onChanged: (FilterOption value) {
                    Navigator.pop(context);
                    setState(() {
                      _filterOption = value;
                    });
                  },
                ),
                RadioListTile<FilterOption>(
                  title: const Text('On Review'),
                  value: FilterOption.onReview,
                  groupValue: _filterOption,
                  onChanged: (FilterOption value) {
                    Navigator.pop(context);
                    setState(() {
                      _filterOption = value;
                    });
                  },
                ),
                RadioListTile<FilterOption>(
                  title: const Text('Accepted'),
                  value: FilterOption.accepted,
                  groupValue: _filterOption,
                  onChanged: (FilterOption value) {
                    Navigator.pop(context);
                    setState(() {
                      _filterOption = value;
                    });
                  },
                ),
                RadioListTile<FilterOption>(
                  title: const Text('Rejected'),
                  value: FilterOption.rejected,
                  groupValue: _filterOption,
                  onChanged: (FilterOption value) {
                    Navigator.pop(context);
                    setState(() {
                      _filterOption = value;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LogoutBloc>(
        create: (BuildContext context) => _logoutBloc,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: CustomBody(
              appBarLeading: IconButton(
                icon: Icon(FontAwesomeIcons.stream,
                    color: Colors.black87, size: 20.0),
                onPressed: () {
                  // drawer
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              appBarTitle: Text(
                "Help The Child",
                style: GoogleFonts.patuaOne().copyWith(color: Colors.black87),
              ),
              appBarActions: <Widget>[
                IconButton(
                  tooltip: "Filter",
                  icon: Icon(FontAwesomeIcons.filter,
                      color: Colors.black87, size: 20.0),
                  onPressed: _buildBottomSheet,
                )
              ],
              body: !_isLoading
                  ? Body(
                      filterOption: _filterOption == FilterOption.accepted
                          ? "accepted"
                          : _filterOption == FilterOption.onReview
                              ? "on review"
                              : _filterOption == FilterOption.rejected
                                  ? "rejected"
                                  : _filterOption == FilterOption.sent
                                      ? "sent"
                                      : null,
                    )
                  : CustomCenter(
                      child: CircularProgressIndicator(),
                    ),
            ),
            drawer: _buildDrawer()),
      ),
    );
  }
}
