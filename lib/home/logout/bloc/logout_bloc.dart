import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../user_repo/user_repository.dart';
import './bloc.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  UserRepository _userRepository;

  LogoutBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LogoutState get initialState => LogoutState.empty();

  @override
  Stream<LogoutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    try {
      await _userRepository.signOut();
      yield LogoutState.success();
    } catch (_) {
      yield LogoutState.failure();
    }
  }
}
