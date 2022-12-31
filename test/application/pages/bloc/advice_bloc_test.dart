import 'package:fcl/applicaton_layer/pages/advice/bloc/advice_bloc.dart';
import 'package:test/scaffolding.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group("AdviceBloc", () {
    group("Should Emits", () {
      blocTest<AdviceBloc, AdviceState>(
        "Nothing when no event is added",
        build: () => AdviceBloc(),
        expect: () => const <AdviceState>[],
      );

      blocTest<AdviceBloc, AdviceState>(
        "[AdviceStateLoading, AdviceStateError] when AdviceRequestEvent is added ",
        build: () => AdviceBloc(),
        act: (bloc) => bloc.add(AdviceRequestedEvent()),
        wait: const Duration(seconds: 3),
        expect: () => <AdviceState>[
          AdviceStateLoading(),
          AdviceStateError(message: "error message")
        ],
      );
    });
  });
}
