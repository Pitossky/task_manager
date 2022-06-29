import '../services/validator.dart';

enum EmailForm { signIn, register }

class EmailModel with EmailValidator {
  final String email;
  final String password;
  final EmailForm emailForm;
  final bool loadState;
  final bool submitState;

  EmailModel({
    this.email = '',
    this.password = '',
    this.emailForm = EmailForm.signIn,
    this.loadState = false,
    this.submitState = false,
  });

  String get primaryEmailBtn {
    return emailForm == EmailForm.signIn ? 'Sign In' : 'Register';
  }

  String get secondaryEmailBtn {
    return emailForm == EmailForm.signIn
        ? "Don't have an account? Register"
        : 'Have an account? Sign In';
  }

  bool get validateSubmission {
    return emailValidator.validForm(email) &&
        emailValidator.validForm(password) &&
        !loadState;
  }

  String? get passCheck {
    bool validPass = submitState && !emailValidator.validForm(password);
    return validPass ? "Password can't be empty" : null;
  }

  String? get emCheck {
    bool validEmail = submitState && !emailValidator.validForm(email);
    return validEmail ? "Email can't be empty" : null;
  }

  EmailModel copyWith({
    required String email,
    required String password,
    required EmailForm emailForm,
    required bool loadState,
    required bool submitState,
  }) {
    return EmailModel(
      email: email,
      password: password,
      emailForm: emailForm,
      loadState: loadState,
      submitState: submitState,
    );
  }
}
