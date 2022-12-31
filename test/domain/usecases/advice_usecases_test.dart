import 'package:dartz/dartz.dart';
import 'package:fcl/data_layer/repositories/advice_repo_impl.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:fcl/domain_layer/usecases/advice_usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'advice_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRepoImpl>()])
void main() {
  group("AdviceUseCases", () {
    final mockAdviceRepoImpl = MockAdviceRepoImpl();
    final adviceUseCasesUnderTest =
        AdviceUseCases(adviceRepo: mockAdviceRepoImpl);
    group("Should return AdviceEntity", () {
      test("When AdviceRepoImpl returns a AdviceModel", () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(
                const Right(AdviceEntity(advice: "test", id: 42))));

        final result = await adviceUseCasesUnderTest.getAdvice();
        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            const Right<Failure, AdviceEntity>(
                AdviceEntity(advice: "test", id: 42)));
        verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });
    });

    group("Should return left with", () {
      test("a ServerFailure", () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(Left(ServerFailure())));

        final result = await adviceUseCasesUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
        verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });

      test("a GeneralFailure", () async {
        when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(Left(GeneralFailure())));

        final result = await adviceUseCasesUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
        verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });
    });
  });
}
