import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_repo/user_repository.dart';
import 'bloc/bloc.dart';
import 'login_form.dart';
// import 'package:flutter_firebase_login/login/login.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocProvider<LoginBloc>(
            create: (BuildContext context) => _loginBloc,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Opacity(
                    child: Image.asset(
                      "assets/images/bg.jpg",
                      fit: BoxFit.cover,
                    ),
                    opacity: 0.5,
                  ),
                ),
                LoginForm(userRepository: _userRepository),
              ],
            )));
  }
}
