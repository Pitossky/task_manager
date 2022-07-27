import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/model/email_model.dart';
import '../authentication.dart';

class EmailModelBloc {
  final AuthAbstract auth;
  EmailModelBloc({required this.auth});

  final _modelSubject = BehaviorSubject<EmailModel>.seeded(
    EmailModel(),
  );

  Stream<EmailModel> get emailStream => _modelSubject.stream;
  EmailModel get _emailModel => _modelSubject.value;

  void dispose() => _modelSubject.close();

  void emailBlocUpdate({
    String email = '',
    String password = '',
    EmailForm emailForm = EmailForm.signIn,
    bool loadState = false,
    bool submitState = false,
  }) {
    _modelSubject.value = _emailModel.copyWith(
      email: email,
      password: password,
      emailForm: emailForm,
      loadState: loadState,
      submitState: submitState,
    );
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
