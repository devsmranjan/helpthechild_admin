import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

// if the authentication state was uninitialized, the user might be seeing a splash screen
class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

// if the authentication state was authenticated, the user might see a home screen.
class Authenticated extends AuthenticationState {
  final String uid;

  Authenticated(this.uid);

  @override
  List<Object> get props => [uid];

  @override
  String toString() => 'Authenticated { uid: $uid}';
}

// if the authentication state was unauthenticated, the user might see a login form.
class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Unauthenticated';
}
