import 'package:fcl/data_layer/datasources/advice_remote_datasource.dart';
import 'package:fcl/data_layer/exceptions/exceptions.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:fcl/domain_layer/repositories/advice_repo.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDataSource adviceRemoteDataSource;
  AdviceRepoImpl({required this.adviceRemoteDataSource});

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      final result = await adviceRemoteDataSource.getRandomAdviceFromApi();
      return right(result);
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }
}
