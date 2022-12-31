import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fcl/data_layer/datasources/advice_remote_datasource.dart';
import 'package:fcl/data_layer/exceptions/exceptions.dart';
import 'package:fcl/data_layer/models/advice_model.dart';
import 'package:fcl/data_layer/repositories/advice_repo_impl.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'advice_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRemoteDataSourceImpl>()])
void main() {
  final mockAdviceRemoteDataSource = MockAdviceRemoteDataSourceImpl();
  final adviceRepoImplUnderTest =
      AdviceRepoImpl(adviceRemoteDataSource: mockAdviceRemoteDataSource);
  group('AdviceRepoImpl', () {
    group('Should return AdviceEntity', () {
      test('When AdviceRemoteDataSource returns Advice Model', () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenAnswer(
            (realInvocation) =>
                Future.value(AdviceModel(advice: "test", id: 42)));

        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result,
            Right<Failure, AdviceModel>(AdviceModel(advice: "test", id: 42)));

        verify(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).called(1);
        verifyNoMoreInteractions(mockAdviceRemoteDataSource);
      });
    });

    group("Should return left with", () {
      test("A ServerFailure when a ServerException occurs", () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(ServerException());
        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
      });

      test("A GeneralFailure on all other Exceptions", () async {
        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(const SocketException('test'));
        final result = await adviceRepoImplUnderTest.getAdviceFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
      });
    });
  });
}
