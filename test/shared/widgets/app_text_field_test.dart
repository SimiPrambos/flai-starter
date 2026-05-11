import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/app_text_field.dart';

void main() {
  group('AppTextField', () {
    testWidgets('forwards configuration to TextFormField', (tester) async {
      final controller = TextEditingController(text: 'initial');
      final formKey = GlobalKey<FormState>();
      addTearDown(controller.dispose);
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextField(
                label: 'Password',
                hint: 'Enter password',
                controller: controller,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: const Icon(Icons.visibility),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'secret');

      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      final textField = tester.widget<TextField>(
        find.byType(TextField),
      );
      final decoration = textField.decoration!;

      expect(textFormField.controller, controller);
      expect(textField.obscureText, isTrue);
      expect(textField.keyboardType, TextInputType.visiblePassword);
      expect(decoration.labelText, 'Password');
      expect(decoration.hintText, 'Enter password');
      expect(decoration.prefixIcon, isA<Icon>());
      expect(decoration.suffixIcon, isA<Icon>());
      expect(changedValue, 'secret');
      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
