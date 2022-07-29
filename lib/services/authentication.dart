import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthAbstract {
  User? get currentUser;
  Future<User?> anomSignIn();
  Future<void> anomSignOut();
  Stream<User?> authState();
  Future<User?> googleSignIn();
  Future<User?> facebookSignIn();
  Future<User?>? emailSignIn(String? email, String? password);
  Future<User?> emailCreate(String email, String password);
}

class Authentication implements AuthAbstract {
  final _firebase = FirebaseAuth.instance;

  @override
  Stream<User?> authState() => _firebase.authStateChanges();

  @override
  User? get currentUser => _firebase.currentUser;

  @override
  Future<User?> anomSignIn() async {
    final anomUser = await _firebase.signInAnonymously();
    return anomUser.user;
  }

  @override
  Future<User?> googleSignIn() async {
    final googleSign = GoogleSignIn();
    final googleUser = await googleSign.signIn();
    if (googleUser != null) {
      final auth = await googleUser.authentication;
      if (auth.idToken != null) {
        final userAccess = await _firebase.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: auth.idToken,
            accessToken: auth.accessToken,
          ),
        );
        return userAccess.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google Id Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> facebookSignIn() async {
    final fbUser = FacebookLogin();
    final loginResponse = await fbUser.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);
    switch (loginResponse.status) {
      case FacebookLoginStatus.success:
        final accessToken = loginResponse.accessToken;
        final cred = await _firebase.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return cred.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: loginResponse.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User?>? emailSignIn(String? email, String? password) async {
    final user = await _firebase.signInWithCredential(
      EmailAuthProvider.credential(
        email: email!,
        password: password!,
      ),
    );
    return user.user;
  }

  @override
  Future<User?> emailCreate(String email, String password) async {
    final user = await _firebase.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user.user;
  }

  @override
  Future<void> anomSignOut() async {
    final signIn = GoogleSignIn();
    await signIn.signOut();
    final fbUser = FacebookLogin();
    await fbUser.logOut();
    await _firebase.signOut();
  }
}
