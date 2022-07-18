import 'dart:async';
import 'package:task_manager/model/email_model.dart';
import '../authentication.dart';

class EmailModelBloc {
  final AuthAbstract auth;
  EmailModelBloc({required this.auth});

  final StreamController<EmailModel> _emailStreamController =
      StreamController<EmailModel>();
  Stream<EmailModel> get emailStream => _emailStreamController.stream;
  EmailModel _emailModel = EmailModel();

  void dispose() => _emailStreamController.close();

  void emailBlocUpdate({
    String email = '',
    String password = '',
    EmailForm emailForm = EmailForm.signIn,
    bool loadState = false,
    bool submitState = false,
  }) {
    _emailModel = _emailModel.copyWith(
      email: email,
      password: password,
      emailForm: emailForm,
      loadState: loadState,
      submitState: submitState,
    );
    _emailStreamController.add(_emailModel);
  }

  void toggleForm() {
    emailBlocUpdate(
      email: '',
      password: '',
      emailForm: _emailModel.emailForm == EmailForm.signIn
          ? EmailForm.register
          : EmailForm.signIn,
      loadState: false,
      submitState: false,
    );
  }

  void updateEmail(String email) => emailBlocUpdate(
        email: email,
      );

  void updatePassword(String password) => emailBlocUpdate(
        password: password,
      );

  Future<void> submitEmail() async {
    emailBlocUpdate(loadState: true, submitState: true);
    try {
      //await Future.delayed(const Duration(seconds: 3));
      if (_emailModel.emailForm == EmailForm.signIn) {
        await auth.emailSignIn(
          _emailModel.email,
          _emailModel.password,
        );
      } else {
        await auth.emailCreate(
          _emailModel.email,
          _emailModel.password,
        );
      }
    } catch (error) {
      emailBlocUpdate(loadState: false);
      rethrow;
    }
  }
}
