import 'package:bloc_test/bloc_test.dart';
import 'package:fcl/applicaton_layer/core/services/theme_service.dart';
import 'package:fcl/applicaton_layer/pages/advice/advice_page.dart';
import 'package:fcl/applicaton_layer/pages/advice/cubit/advice_cubit.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/advice_field.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAdvicerCubit extends MockCubit<AdviceCubitState>
    implements AdviceCubit {}

void main() {
  Widget widgetUnderTest({required AdviceCubit cubit}) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ThemeService(),
        child: BlocProvider<AdviceCubit>(
          create: (context) => cubit,
          child: const AdvicePage(),
        ),
      ),
    );
  }

  group("AdvicePage", () {
    final mockAdviceCubit = MockAdvicerCubit();
    group("Should be displayed in ViewState", () {
      testWidgets(
        "Initial when Cubits emits AdviceInitial",
        (widgetTester) async {
          whenListen(
              mockAdviceCubit, Stream.fromIterable([const AdviceInitial()]),
              initialState: const AdviceInitial());

          await widgetTester
              .pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));

          final adviceInitialTextFinder =
              find.text("Your Advice is waiting for you");
          expect(adviceInitialTextFinder, findsOneWidget);
        },
      );

      testWidgets(
        "Loading when Cubits emits AdviceLoadingState",
        (widgetTester) async {
          whenListen(mockAdviceCubit,
              Stream.fromIterable([const AdviceStateLoading()]),
              initialState: const AdviceInitial());

          await widgetTester
              .pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
          await widgetTester.pump();

          final adviceInitialTextFinder =
              find.byType(CircularProgressIndicator);
          expect(adviceInitialTextFinder, findsOneWidget);
        },
      );

      testWidgets(
        "Show adviceText when Cubits emits AdviceLoadedState",
        (widgetTester) async {
          whenListen(mockAdviceCubit,
              Stream.fromIterable([const AdviceStateLoaded(advice: "42")]),
              initialState: const AdviceInitial());

          await widgetTester
              .pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
          await widgetTester.pump();

          final adviceLoadedStateFinder = find.byType(AdviceField);
          final adviceText =
              widgetTester.widget<AdviceField>(adviceLoadedStateFinder).advice;

          expect(adviceLoadedStateFinder, findsOneWidget);
          expect(adviceText, "42");
        },
      );

      testWidgets(
        "Error when Cubits emits AdviceErrorState",
        (widgetTester) async {
          whenListen(mockAdviceCubit,
              Stream.fromIterable([const AdviceStateError(message: "error")]),
              initialState: const AdviceInitial());

          await widgetTester
              .pumpWidget(widgetUnderTest(cubit: mockAdviceCubit));
          await widgetTester.pump();

          final adviceInitialTextFinder = find.byType(ErrorMessage);
          expect(adviceInitialTextFinder, findsOneWidget);
        },
      );
    });
  });
}
