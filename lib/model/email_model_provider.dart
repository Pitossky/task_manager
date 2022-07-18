import 'package:flutter/cupertino.dart';
import 'package:task_manager/services/authentication.dart';
import '../services/validator.dart';
import 'email_model.dart';

class EmailModelChangeNotifier with EmailValidator, ChangeNotifier {
  String emailProvider;
  String passwordProvider;
  EmailForm emailFormProvider;
  bool loadStateProvider;
  bool submitStateProvider;
  final AuthAbstract auth;

  EmailModelChangeNotifier({
    this.emailProvider = '',
    this.passwordProvider = '',
    this.emailFormProvider = EmailForm.signIn,
    this.loadStateProvider = false,
    this.submitStateProvider = false,
    required this.auth,
  });

  String get primaryEmailBtn {
    return emailFormProvider == EmailForm.signIn ? 'Sign In' : 'Register';
  }

  String get secondaryEmailBtn {
    return emailFormProvider == EmailForm.signIn
        ? "Don't have an account? Register"
        : 'Have an account? Sign In';
  }

  bool get validateSubmission {
    return emailValidator.validForm(emailProvider) &&
        emailValidator.validForm(passwordProvider) &&
        !loadStateProvider;
  }

  String? get passCheck {
    bool validPass = submitStateProvider && !emailValidator.validForm(passwordProvider);
    return validPass ? "Password can't be empty" : null;
  }

  String? get emCheck {
    bool validEmail = submitStateProvider && !emailValidator.validForm(emailProvider);
    return validEmail ? "Email can't be empty" : null;
  }

  void toggleForm() {
    updateWith(
      email: '',
      password: '',
      emailForm: emailFormProvider == EmailForm.signIn
          ? EmailForm.register
          : EmailForm.signIn,
      loadState: false,
      submitState: false,
    );
  }

  void updateEmail(String email) => updateWith(
    email: email,
  );

  void updatePassword(String password) => updateWith(
    password: password,
  );

  Future<void> submitEmail() async {
    updateWith(loadState: true, submitState: true);
    try {
      //await Future.delayed(const Duration(seconds: 3));
      if (emailFormProvider == EmailForm.signIn) {
        await auth.emailSignIn(
          emailProvider,
          passwordProvider,
        );
      } else {
        await auth.emailCreate(
          emailProvider,
          passwordProvider,
        );
      }
    } catch (error) {
      updateWith(loadState: false);
      rethrow;
    }
  }

  void updateWith({
    String? email,
    String? password,
    EmailForm? emailForm,
    bool? loadState,
    bool? submitState,
  }) {
    emailProvider = email ?? emailProvider;
    passwordProvider = password ?? passwordProvider;
    emailFormProvider = emailForm ?? emailFormProvider;
    loadStateProvider = loadState ?? loadStateProvider;
    submitStateProvider = submitState ?? submitStateProvider;
    notifyListeners();
  }
}
