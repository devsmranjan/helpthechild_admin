import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'authentication/bloc.dart';
import 'login/login_screen.dart';
import 'splash_screen/splash_screen.dart';
import 'user_repo/user_repository.dart';

class HelpTheChildClient extends StatefulWidget {
  @override
  _HelpTheChildClientState createState() => _HelpTheChildClientState();
}

class _HelpTheChildClientState extends State<HelpTheChildClient> {
  final UserRepository _userRepository = UserRepository();

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => _authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF89AB30),
            accentColor: const Color(0xFFDBA716),
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              return Home(uid: state.uid, userRepository: _userRepository,);
            }

            return Container();
          },
        ),
      ),
    );
  }
}
