import 'package:fcl/applicaton_layer/core/constants/api_constants.dart';
import 'package:fcl/data_layer/datasources/advice_remote_datasource.dart';
import 'package:fcl/data_layer/exceptions/exceptions.dart';
import 'package:fcl/data_layer/models/advice_model.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

import 'advice_remote_datasource._test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  group('AdviceRemoteDataSource', () {
    final mockClient = MockClient();
    final adviceRemoteDataSourceUnderTest =
        AdviceRemoteDataSourceImpl(client: mockClient);
    group('Should return AdviceModel', () {
      test('When Client response 200 and has valid data', () async {
        const responseBody = '{"advice": "test advice", "advice_id": 1}';

        when(mockClient.get(
          Uri.parse(ApiConstants.baseURL),
          headers: ApiConstants.baseHeader,
        )).thenAnswer(
            (realInvocation) => Future.value(Response(responseBody, 200)));

        final result =
            await adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi();

        expect(result, AdviceModel(advice: "test advice", id: 1));
      });
    });

    group('Should throw', () {
      test("a ServerException when Client response is not 200", () {
        when(mockClient.get(
          Uri.parse(ApiConstants.baseURL),
          headers: ApiConstants.baseHeader,
        )).thenAnswer((realInvocation) => Future.value(Response('', 201)));

        expect(() => adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<ServerException>()));
      });

      test("a TypeError when Client response was 200 and no valid data", () {
        const responseBody = '{"advice": "test advice"}';

        when(mockClient.get(
          Uri.parse(ApiConstants.baseURL),
          headers: ApiConstants.baseHeader,
        )).thenAnswer(
            (realInvocation) => Future.value(Response(responseBody, 200)));

        expect(() => adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<TypeError>()));
      });
    });
  });
}
