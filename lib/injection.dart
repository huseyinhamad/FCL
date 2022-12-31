import 'package:fcl/applicaton_layer/pages/advice/cubit/advice_cubit.dart';
import 'package:fcl/data_layer/datasources/advice_remote_datasource.dart';
import 'package:fcl/data_layer/repositories/advice_repo_impl.dart';
import 'package:fcl/domain_layer/repositories/advice_repo.dart';
import 'package:fcl/domain_layer/usecases/advice_usecases.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> init() async {
  // Application Layer
  locator.registerFactory(() => AdviceCubit(adviceUseCases: locator()));

  // Domain Layer
  locator.registerFactory(() => AdviceUseCases(adviceRepo: locator()));

  // Data Layer
  locator.registerFactory<AdviceRepo>(
      () => AdviceRepoImpl(adviceRemoteDataSource: locator()));

  // Datasource Layer
  locator.registerFactory<AdviceRemoteDataSource>(
      () => AdviceRemoteDataSourceImpl(client: locator()));

  // Externs
  locator.registerFactory(() => http.Client());

  return Future.value();
}
