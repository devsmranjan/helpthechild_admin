import 'package:meta/meta.dart';

@immutable
class LogoutState {
  final bool isLogOutSubmitting;
  final bool isLogOutSuccess;
  final bool isLogOutFailure;

  LogoutState({
    @required this.isLogOutSubmitting,
    @required this.isLogOutSuccess,
    @required this.isLogOutFailure,
  });

// empty is the initial state of the Log outForm.
  factory LogoutState.empty() {
    return LogoutState(
      isLogOutSubmitting: false,
      isLogOutSuccess: false,
      isLogOutFailure: false,
    );
  }

// loading is the state of the Log outForm when we are validating credentials
  factory LogoutState.loading() {
    return LogoutState(
        isLogOutSubmitting: true,
        isLogOutSuccess: false,
        isLogOutFailure: false);
  }

// failure is the state of the Log out Form when a Log out attempt has failed.
  factory LogoutState.failure() {
    return LogoutState(
        isLogOutSubmitting: false,
        isLogOutSuccess: false,
        isLogOutFailure: true);
  }

// success is the state of the Log outForm when a Log out attempt has succeeded.
  factory LogoutState.success() {
    return LogoutState(
        isLogOutSubmitting: false,
        isLogOutSuccess: true,
        isLogOutFailure: false);
  }
}
