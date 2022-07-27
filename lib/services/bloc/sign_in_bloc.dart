import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_manager/services/authentication.dart';

class SignInBloc {
  final AuthAbstract auth;
  final ValueNotifier<bool> signState;
  SignInBloc({required this.auth, required this.signState});

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      signState.value = true;
      return await signInMethod();
    } catch (error) {
      signState.value = false;
      rethrow;
    }
  }

  Future<User?> anomSignIn() async => await _signIn(auth.anomSignIn);
  Future<User?> googleSignIn() async => await _signIn(auth.googleSignIn);
  Future<User?> facebookSignIn() async => await _signIn(auth.facebookSignIn);
}
