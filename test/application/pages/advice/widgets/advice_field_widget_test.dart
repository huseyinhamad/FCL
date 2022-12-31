import 'package:fcl/applicaton_layer/pages/advice/widgets/advice_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AdviceField", () {
    Widget widgetUnderTest({required String adviceText}) {
      return MaterialApp(
          home: AdviceField(
        advice: adviceText,
      ));
    }

    group("Should be displayed correctly", () {
      testWidgets("When a short text is given", (widgetTester) async {
        const textForTest = "a";

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: textForTest));
        await widgetTester.pumpAndSettle();

        final adviceFieldFinder = find.textContaining("a");
        expect(adviceFieldFinder, findsAtLeastNWidgets(1));
      });

      testWidgets("When a long text is given", (widgetTester) async {
        const textForTest =
            "Happy new year. I hope new year brings joy,health and success in all aspects of life";

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: textForTest));
        await widgetTester.pumpAndSettle();

        final adviceFieldFinder = find.byType(AdviceField);
        expect(adviceFieldFinder, findsAtLeastNWidgets(1));
      });

      testWidgets("When no text is given", (widgetTester) async {
        const textForTest = '';

        await widgetTester.pumpWidget(widgetUnderTest(adviceText: textForTest));
        await widgetTester.pumpAndSettle();

        final adviceFieldFinder = find.byType(AdviceField);
        expect(adviceFieldFinder, findsAtLeastNWidgets(1));
      });
    });
  });
}
