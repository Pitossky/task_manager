//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/services/validator.dart';
import '../model/email_model.dart';
import '../services/authentication.dart';
import '../widgets/exception_alert.dart';

class EmailScreen extends StatefulWidget with EmailValidator {
  EmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailForm _formType = EmailForm.signIn;
  bool _formSubmit = false;
  bool _formLoading = false;

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
    setState(() {
      _formSubmit = true;
      _formLoading = true;
    });
    try {
      //await Future.delayed(const Duration(seconds: 3));
      final auth = Provider.of<AuthAbstract>(context, listen: false);
      if (_formType == EmailForm.signIn) {
        await auth.emailSignIn(
          _email,
          _password,
        );
      } else {
        await auth.emailCreate(
          _email,
          _password,
        );
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      errorAlert(
        context,
        errorTitle: 'Sign in failed',
        errorMsg: error,
      );
    } finally {
      setState(() {
        _formLoading = false;
      });
    }
  }

  void _emailEdit() {
    final newFocus =
        widget.emailValidator.validForm(_email) ? _passwordFocus : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleForm() {
    setState(() {
      _formSubmit = false;
      _formType =
          _formType == EmailForm.signIn ? EmailForm.register : EmailForm.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateForm() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final buttonTextOne =
        _formType == EmailForm.signIn ? 'Sign In' : 'Register';
    final buttonTextTwo = _formType == EmailForm.signIn
        ? "Don't have an account? Register"
        : 'Have an account? Sign In';

    bool submit = widget.emailValidator.validForm(_email) &&
        widget.emailValidator.validForm(_password) &&
        !_formLoading;

    bool validEmail = _formSubmit && !widget.emailValidator.validForm(_email);
    bool validPass = _formSubmit && !widget.emailValidator.validForm(_password);

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
                      errorText: validEmail ? "Email can't be empty" : null,
                      enabled: _formLoading == false,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: _emailEdit,
                    onChanged: (email) => _updateForm(),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: validPass ? "Password can't be empty" : null,
                      enabled: _formLoading == false,
                    ),
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _submitRaisedButton,
                    onChanged: (pass) => _updateForm(),
                  ),
                  const SizedBox(height: 5),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: submit ? _submitRaisedButton : null,
                    child: Text(
                      buttonTextOne,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: !_formLoading ? _toggleForm : null,
                    child: Text(buttonTextTwo),
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
