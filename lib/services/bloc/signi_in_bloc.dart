import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/services/authentication.dart';

class SignInBloc {
  final AuthAbstract auth;
  SignInBloc({required this.auth});

  final StreamController<bool> _signInStateController =
      StreamController<bool>();
  Stream<bool> get signInStream => _signInStateController.stream;

  void dispose() {
    _signInStateController.close();
  }

  void _setSignInState(bool signInState) =>
      _signInStateController.add(signInState);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setSignInState(true);
      return await signInMethod();
    } catch (error) {
      _setSignInState(false);
      rethrow;
    }
  }

  Future<User?> anomSignIn() async => await _signIn(auth.anomSignIn);
  Future<User?> googleSignIn() async => await _signIn(auth.googleSignIn);
  Future<User?> facebookSignIn() async => await _signIn(auth.facebookSignIn);
}
