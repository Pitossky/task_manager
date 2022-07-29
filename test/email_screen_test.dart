import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/email_screen.dart';
import 'package:task_manager/services/authentication.dart';

class MockAuthentication extends Mock implements AuthAbstract {}

void main() {
  late MockAuthentication mockAuth;

  setUp(() {
    mockAuth = MockAuthentication();
  });

  Future<void> pumpEmailScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthAbstract>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailScreen(),
          ),
        ),
      ),
    );
  }

  group('sign in', () {
    testWidgets(
        "WHEN user doesn't enter the email and password "
        "AND user taps on the sign-in button "
        "THEN signInWithEmailAndPassword is not called",
        (WidgetTester tester) async {
      await pumpEmailScreen(tester);
      final signInBtn = find.text('Sign In');
      await tester.tap(signInBtn);
      verifyNever(
        mockAuth.emailSignIn(
          any,
          any,
        ),
      );
    });

    testWidgets(
        "WHEN user enters the email and password "
        "AND user taps on the sign-in button "
        "THEN signInWithEmailAndPassword is called",
        (WidgetTester tester) async {
      await pumpEmailScreen(tester);
      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(
        const Key('email'),
      );
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passField = find.byKey(
        const Key('password'),
      );
      expect(passField, findsOneWidget);
      await tester.enterText(passField, password);

      await tester.pump();

      final signInBtn = find.text('Sign In');
      await tester.tap(signInBtn);
      verify(
        mockAuth.emailSignIn(
          email,
          password,
        ),
      ).called(1);
    });
  });
}
