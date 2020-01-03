import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_body.dart';
import '../data_classes/profile_data.dart';

import 'body.dart';

class StatusUpdate extends StatelessWidget {
  final ProfileData profileData;

  const StatusUpdate({Key key, @required this.profileData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBody(
        appBarLeading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.times,
            size: 20.0,
            color: Colors.black87,
          ),
        ),
        appBarTitle: Text(""),
        appBarTitleAfterScroll: Text("Pralipa Nayak",
            style: GoogleFonts.patuaOne().copyWith(color: Colors.black87)),
        body: Body(profileData: profileData,),
      ),
    );
  }
}
