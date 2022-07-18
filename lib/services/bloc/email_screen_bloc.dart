//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/services/bloc/email_bloc.dart';
import '../../model/email_model.dart';
import '../authentication.dart';
import '../../widgets/exception_alert.dart';

class EmailScreenBloc extends StatefulWidget {
  final EmailModelBloc emailBloc;

  EmailScreenBloc({
    Key? key,
    required this.emailBloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthAbstract>(context, listen: false);
    return Provider<EmailModelBloc>(
      create: (_) => EmailModelBloc(auth: auth),
      child: Consumer<EmailModelBloc>(
        builder: (_, bloc, __) => EmailScreenBloc(emailBloc: bloc),
      ),
      dispose: (_, bk) => bk.dispose(),
    );
  }

  @override
  State<EmailScreenBloc> createState() => _EmailScreenBlocState();
}

class _EmailScreenBlocState extends State<EmailScreenBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    // print('dispose called');
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submitRaisedButton() async {
    try {
      await widget.emailBloc.submitEmail();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      errorAlert(
        context,
        errorTitle: 'Sign in failed',
        errorMsg: error,
      );
    }
  }

  void _emailEdit(EmailModel model) {
    final newFocus = model.emailValidator.validForm(model.email)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleForm() {
    widget.emailBloc.toggleForm();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool _submitCheck(EmailModel model) {
      return model.validateSubmission;
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sign in'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<EmailModel>(
            stream: widget.emailBloc.emailStream,
            initialData: EmailModel(),
            builder: (context, snapshot) {
              final EmailModel? model = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          focusNode: _emailFocus,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: model!.emCheck,
                            enabled: model.loadState == false,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => _emailEdit(model),
                          onChanged: widget.emailBloc.updateEmail,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: model.passCheck,
                            enabled: model.loadState == false,
                          ),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _submitRaisedButton,
                          onChanged: widget.emailBloc.updatePassword,
                        ),
                        const SizedBox(height: 5),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed:
                              _submitCheck(model) ? _submitRaisedButton : null,
                          child: Text(
                            model.primaryEmailBtn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: model.loadState ? _toggleForm : null,
                          child: Text(model.secondaryEmailBtn),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
