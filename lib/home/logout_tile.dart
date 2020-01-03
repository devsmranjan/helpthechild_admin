import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/bloc.dart';
import '../home/logout/bloc/bloc.dart';
import 'logout/bloc/logout_bloc.dart';
import 'logout/bloc/logout_state.dart';

class LogoutTile extends StatefulWidget {
  @override
  _LogoutTileState createState() => _LogoutTileState();
}

class _LogoutTileState extends State<LogoutTile> {
  LogoutBloc _logoutBloc;

  @override
  void initState() {
    super.initState();
    _logoutBloc = BlocProvider.of<LogoutBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return BlocListener(
                  bloc: _logoutBloc,
                  listener: (BuildContext context, LogoutState state) {
                    if (state.isLogOutFailure) {
                      Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Logout Failure'),
                                Icon(Icons.error)
                              ],
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                    }

                    if (state.isLogOutSubmitting) {
                      Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Logging Out...'),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                    }

                    if (state.isLogOutSuccess) {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut());
                    }
                  },
                  child: BlocBuilder(
                    bloc: _logoutBloc,
                    builder: (context, state) {
                      return AlertDialog(
                        title: Text(
                          "Are you sure to sign out?",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("NO"),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              _logoutBloc.add(LogoutButtonPressed());
                            },
                            child: Text("YES"),
                          )
                        ],
                      );
                    },
                  ));
            });
      },
      leading: Icon(Icons.exit_to_app),
      title: Text("Sign out"),
    );
  }
}
