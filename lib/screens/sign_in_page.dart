import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/email_screen.dart';
import 'package:task_manager/services/authentication.dart';
import 'package:task_manager/services/bloc/signi_in_bloc.dart';
import 'package:task_manager/widgets/exception_alert.dart';
import '../widgets/exports.dart';
import '../services/bloc/email_screen_bloc.dart';
import '../model/email_screen_provider.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc signBloc;
  final bool signLoadState;

  const SignInPage({
    Key? key,
    required this.signBloc,
    required this.signLoadState,
  }) : super(key: key);

  static Widget createSignInBloc(BuildContext context) {
    final auth = Provider.of<AuthAbstract>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, signState, __) {
          return Provider<SignInBloc>(
            create: (_) => SignInBloc(
              auth: auth,
              signState: signState,
            ),
            child: Consumer<SignInBloc>(
              builder: (_, bloc, __) {
                return SignInPage(
                  signBloc: bloc,
                  signLoadState: signState.value,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _signInError(
    BuildContext context,
    Exception exception,
  ) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    errorAlert(
      context,
      errorTitle: 'Sign in failed',
      errorMsg: exception,
    );
  }

  Future<void> _anonymous(BuildContext context) async {
    try {
      await signBloc.anomSignIn();
    } on Exception catch (e) {
      _signInError(context, e);
    }
  }

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      await signBloc.googleSignIn();
    } on Exception catch (e) {
      _signInError(context, e);
    }
  }

  Future<void> _facebookSignIn(BuildContext context) async {
    try {
      await signBloc.facebookSignIn();
    } on Exception catch (e) {
      _signInError(context, e);
    }
  }

  void _emailScreenNav(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        //fullscreenDialog: true,
        builder: (_) =>  EmailScreenProvider.create(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final signState = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Task Manager'),
        elevation: 0,
      ),
      body: SignInColumn(
        anonButton: () => _anonymous(context),
        googleButton: () => _googleSignIn(context),
        facebookButton: () => _facebookSignIn(context),
        emailNav: () => _emailScreenNav(context),
        loadState: signLoadState,
      ),
    );
  }
}
