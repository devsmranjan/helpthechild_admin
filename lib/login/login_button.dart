import 'package:flutter/material.dart';
import '../user_repo/user_repository.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {



  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: EdgeInsets.all(14.0),
      onPressed: widget._onPressed,
      child: Text('LOGIN', style: TextStyle(color: Colors.white),),
      color: Theme.of(context).accentColor,
    );
  }
}