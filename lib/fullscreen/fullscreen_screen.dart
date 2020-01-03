import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Fullscreen extends StatelessWidget {
  final name;
  final imgURL;

  const Fullscreen({Key key, @required this.name, @required this.imgURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          name,
          style: GoogleFonts.patuaOne().copyWith(color: Colors.white)
        ),
        elevation: 0.4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FontAwesomeIcons.times, size: 20.0, color: Colors.white,),
        ),
      ),
      body: Center(
        child: Hero(
          tag: "child photo",
          child: CachedNetworkImage(
            imageUrl: imgURL,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
