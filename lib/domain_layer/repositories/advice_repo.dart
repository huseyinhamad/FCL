import 'package:dartz/dartz.dart';
import 'package:fcl/domain_layer/entities/advice.entity.dart';
import 'package:fcl/domain_layer/failures/failures.dart';

abstract class AdviceRepo {
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource();
}
