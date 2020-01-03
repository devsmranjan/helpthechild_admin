import 'package:flutter/material.dart';

class CustomBody extends StatefulWidget {
  final Widget appBarTitle;
  final Widget appBarTitleAfterScroll;
  final Widget appBarLeading;
  final Widget appBarLeadingAfterScroll;
  final List<Widget> appBarActions;
  final List<Widget> appBarActionsAfterScroll;
  final Color appBarColor;
  final Color appBarColorAfterScroll;
  final body;
  final scrollOffset;
  final Widget appBarBottom;
  final appBarBottomSize;

  const CustomBody({
    Key key,
    @required this.appBarTitle,
    this.appBarTitleAfterScroll,
    @required this.appBarLeading,
    this.appBarLeadingAfterScroll,
    this.appBarActions,
    this.appBarActionsAfterScroll,
    this.appBarColor = Colors.white,
    this.appBarColorAfterScroll,
    @required this.body,
    this.scrollOffset = 34,
    this.appBarBottom,
    this.appBarBottomSize = 0,
  }) : super(key: key);

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  ScrollController _scrollController = ScrollController();
  double _appBarShadow = 0;
  bool _shouldUpdate = false;

  void _scrollListener() {
    setState(() {
      if (_scrollController.offset >= widget.scrollOffset) {
        _appBarShadow = 2;
        _shouldUpdate = true;
      } else {
        _appBarShadow = 0;
        _shouldUpdate = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor:
        !_shouldUpdate
            ? widget.appBarColor
            : widget.appBarColorAfterScroll != null
                ? widget.appBarColorAfterScroll
                : widget.appBarColor,
        centerTitle: true,
        title: !_shouldUpdate
            ? widget.appBarTitle
            : widget.appBarTitleAfterScroll != null
                ? widget.appBarTitleAfterScroll
                : widget.appBarTitle,
        elevation: _appBarShadow,
        leading: !_shouldUpdate
            ? widget.appBarLeading
            : widget.appBarLeadingAfterScroll != null
                ? widget.appBarLeadingAfterScroll
                : widget.appBarLeading,
        actions: !_shouldUpdate
            ? widget.appBarActions
            : widget.appBarActionsAfterScroll != null
                ? widget.appBarActionsAfterScroll
                : widget.appBarActions,
        bottom: widget.appBarBottomSize != 0
            ? PreferredSize(
                child: widget.appBarBottom,
                preferredSize: widget.appBarBottomSize,
              )
            : null,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: widget.body,
      ),
    );
  }
}
