import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../analysis/data_chart/data_chart.dart';
import '../components/custom_body.dart';
import '../components/custom_center.dart';
import '../data_classes/user_data.dart';

import 'data_chart/data.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Map<String, int> _totalRepetitionArea = {};
  bool _isLoading = true;
  List<ChartData> _chartData = [];
  int _totalLength = 0;

  _getData() {
    Firestore.instance
        .collection('data')
        .where('dist', isEqualTo: userData.dist)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        _totalLength = snapshot.documents.length;
      });
      snapshot.documents.forEach((document) {
        String pin = document.data['pin'];
        if (_totalRepetitionArea.containsKey(pin)) {
          _totalRepetitionArea.update(pin, (value) => value + 1);
        } else {
          _totalRepetitionArea.putIfAbsent(pin, () => 1);
        }
      });


      _totalRepetitionArea.forEach((key, value) {
        double percentage = double.parse(((value / _totalLength) * 100).toStringAsFixed(1));
        _chartData.add(ChartData(key, percentage));
      });

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBody(
          appBarTitle: Text("Analysis",
              style: GoogleFonts.patuaOne().copyWith(color: Colors.black87)),
          appBarLeading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft,
                color: Colors.black87, size: 20.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          body: CustomCenter(
            child: !_isLoading
                ? Container(child: DataChart(chartData : _chartData))
                : CircularProgressIndicator(),
          )),
    );
  }
}
