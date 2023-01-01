import 'package:dartz/dartz.dart';
import 'package:fcl/applicaton_layer/core/constants/api_constants.dart';
import 'package:fcl/applicaton_layer/pages/advice/cubit/advice_cubit.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:fcl/domain_layer/usecases/advice_usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAdviceUseCases extends Mock implements AdviceUseCases {}

void main() {
  group("AdviceCubit", () {
    MockAdviceUseCases mockAdviceUseCases = MockAdviceUseCases();
    group("Should emit", () {
      blocTest<AdviceCubit, AdviceCubitState>(
        "Nothing when no method is called",
        build: () => AdviceCubit(adviceUseCases: mockAdviceUseCases),
        expect: () => const <AdviceCubitState>[],
      );

      blocTest<AdviceCubit, AdviceCubitState>(
        "[AdviceStateLoading, AdviceStateLoaded] when adviceRequested() is called",
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
            (invocation) => Future.value(const Right<Failure, AdviceEntity>(
                AdviceEntity(advice: "advice", id: 1)))),
        build: () => AdviceCubit(adviceUseCases: mockAdviceUseCases),
        act: (cubit) => cubit.adviceRequested(),
        expect: () => const <AdviceCubitState>[
          AdviceStateLoading(),
          AdviceStateLoaded(advice: "advice"),
        ],
      );
      group(
          "[AdviceStateLoading, AdviceStateError] when adviceRequested() is called",
          () {
        blocTest("and a ServerFailure occurs",
            setUp: () => when((() => mockAdviceUseCases.getAdvice()))
                .thenAnswer((invocation) =>
                    Future.value(Left<Failure, AdviceEntity>(ServerFailure()))),
            build: () => AdviceCubit(adviceUseCases: mockAdviceUseCases),
            act: (cubit) => cubit.adviceRequested(),
            expect: () => const <AdviceCubitState>[
                  AdviceStateLoading(),
                  AdviceStateError(message: ApiConstants.serverFailureMessage)
                ]);

        blocTest("and a CacheFailure occurs",
            setUp: () => when((() => mockAdviceUseCases.getAdvice()))
                .thenAnswer((invocation) =>
                    Future.value(Left<Failure, AdviceEntity>(CacheFailure()))),
            build: () => AdviceCubit(adviceUseCases: mockAdviceUseCases),
            act: (cubit) => cubit.adviceRequested(),
            expect: () => const <AdviceCubitState>[
                  AdviceStateLoading(),
                  AdviceStateError(message: ApiConstants.cacheFailureMessage)
                ]);
        blocTest("and a GeneralFailure occurs",
            setUp: () => when((() => mockAdviceUseCases.getAdvice()))
                .thenAnswer((invocation) => Future.value(
                    Left<Failure, AdviceEntity>(GeneralFailure()))),
            build: () => AdviceCubit(adviceUseCases: mockAdviceUseCases),
            act: (cubit) => cubit.adviceRequested(),
            expect: () => const <AdviceCubitState>[
                  AdviceStateLoading(),
                  AdviceStateError(message: ApiConstants.generalFailureMessage)
                ]);
      });
    });
  });
}
