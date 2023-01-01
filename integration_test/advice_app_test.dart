import 'package:fcl/applicaton_layer/pages/advice/widgets/advice_field.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/custom_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fcl/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("End-to-end test", () {
    testWidgets("Tap on CustomButton, verify advice will be loaded",
        (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      //Verify that no advice is loaded
      expect(find.text("Your Advice is waiting for you"), findsOneWidget);

      //Find CustomButton
      expect(find.byType(CustomButton), findsOneWidget);
      final customButtonFinder = find.byType(CustomButton);

      //Emulate a tap on the CustomButton
      await widgetTester.tap(customButtonFinder);

      //Trigger a frame and wait until its settled
      await widgetTester.pumpAndSettle();

      //Verify that an advice was loaded
      expect(find.byType(AdviceField), findsOneWidget);
    });
  });
}
