//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/model/email_model_provider.dart';
import 'package:task_manager/services/bloc/email_bloc.dart';
import 'email_model.dart';
import '../services/authentication.dart';
import '../widgets/exception_alert.dart';

class EmailScreenProvider extends StatefulWidget {
  final EmailModelChangeNotifier model;

  EmailScreenProvider({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthAbstract>(context, listen: false);
    return ChangeNotifierProvider<EmailModelChangeNotifier>(
      create: (_) => EmailModelChangeNotifier(auth: auth),
      child: Consumer<EmailModelChangeNotifier>(
        builder: (_, emailModel, __) => EmailScreenProvider(
          model: emailModel,
        ),
      ),
      // dispose: (_, bk) => bk.dispose(),
    );
  }

  @override
  State<EmailScreenProvider> createState() => _EmailScreenProviderState();
}

class _EmailScreenProviderState extends State<EmailScreenProvider> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  EmailModelChangeNotifier get model => widget.model;

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
      await model.submitEmail();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      errorAlert(
        context,
        errorTitle: 'Sign in failed',
        errorMsg: error,
      );
    }
  }

  void _emailEdit() {
    final newFocus = model.emailValidator.validForm(model.emailProvider)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleForm() {
    model.toggleForm();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool _submitCheck() {
      return model.validateSubmission;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sign in'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      errorText: model.emCheck,
                      enabled: model.loadStateProvider == false,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _emailEdit(),
                    onChanged: model.updateEmail,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: model.passCheck,
                      enabled: model.loadStateProvider == false,
                    ),
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _submitRaisedButton,
                    onChanged: model.updatePassword,
                  ),
                  const SizedBox(height: 5),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: _submitCheck() ? _submitRaisedButton : null,
                    child: Text(
                      model.primaryEmailBtn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: !model.loadStateProvider ? _toggleForm : null,
                    child: Text(model.secondaryEmailBtn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
