import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/widgets/sign_in_button.dart';

void main() {
  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: SignInButton(
        buttonImage: const Text('tap me'),
        buttonAction: () => pressed = true,
      ),
    ));
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('tap me'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
