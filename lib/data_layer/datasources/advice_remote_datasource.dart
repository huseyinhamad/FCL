import 'dart:convert';

import 'package:fcl/applicaton_layer/core/constants/api_constants.dart';
import 'package:fcl/data_layer/exceptions/exceptions.dart';
import 'package:fcl/data_layer/models/advice_model.dart';
import 'package:http/http.dart' as http;

abstract class AdviceRemoteDataSource {
  /// Requests a random advice from api
  /// Returns [AdviceModel] if successfull
  /// Throws a [ServerException] if status is not 200
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final http.Client client;
  AdviceRemoteDataSourceImpl({required this.client});

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final response = await client.get(
      Uri.parse(ApiConstants.baseURL),
      headers: ApiConstants.baseHeader,
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final responseBody = json.decode(response.body);
      return AdviceModel.fromJson(responseBody);
    }
  }
}
