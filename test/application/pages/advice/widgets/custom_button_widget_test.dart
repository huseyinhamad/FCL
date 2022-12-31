import 'package:fcl/applicaton_layer/pages/advice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class OnCustomButtonTap {
  void call();
}

class MockOnCustomButtonTap extends Mock implements OnCustomButtonTap {}

void main() {
  group("CustomButton", () {
    Widget widgetUnderTest({Function()? callback}) {
      return MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onTap: callback?.call(),
          ),
        ),
      );
    }

    group("Is button rendered correctly", () {
      testWidgets("and has all parts it needs", (widgetTester) async {
        await widgetTester.pumpWidget(widgetUnderTest());

        final buttonLabelFinder = find.text("Get Advice");
        expect(buttonLabelFinder, findsOneWidget);
      });
    });

    group("Should handle onTap", () {
      testWidgets(
        "When someone has pressed the button",
        (widgetTester) async {
          final mockOnCustomButtonTap = MockOnCustomButtonTap();
          await widgetTester
              .pumpWidget(widgetUnderTest(callback: mockOnCustomButtonTap));

          final customButtonFinder = find.byType(CustomButton);
          widgetTester.tap(customButtonFinder);
          verify(() => mockOnCustomButtonTap()).called(1);
        },
      );
    });
  });
}
