import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/prediction.dart';
import 'package:flexivity/data/remote/prediction/prediction_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../activity/web_activity_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  MockClient mockClient = MockClient();
  const testCredentials = Credentials(1, 'token', 'token');
  PredictionApi predictionApi = PredictionApi(mockClient, testCredentials);
  dotenv.testLoad();
  setUp(() {
    mockClient = MockClient();
    predictionApi = PredictionApi(mockClient, testCredentials);
  });

  group('Prediction Api', ()
  {
    final testPrediction = Prediction(date: '2021-10-10', score: 10.0);
    final stepGoal = 10000;
    test('getUser returns a GetUserResponse', () async {
      when(
        mockClient.send(any),
      ).thenAnswer(
            (_) async =>
            StreamedResponse(
              Stream.value(
                utf8.encode(
                  '[{"date": "2021-10-10", "score": 10.0}]',
                ),
              ),
              200,
            ),
      );

      final result = await predictionApi.getPrediction();

      verify(mockClient.send(any)).called(1);
      expect(result[0].date, equals(testPrediction.date));
    },

    );
    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));

      expect(
              () async => await predictionApi.getPrediction(), throwsA(isA<ApiException>()));
    });

    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));

      expect(
              () async => await predictionApi.getPrediction(), throwsA(isA<ApiException>()));
    });
    test('getGoal returns a String', () async {
      when(
        mockClient.send(any),
      ).thenAnswer(
            (_) async =>
            StreamedResponse(
              Stream.value(utf8.encode("10000")),
              200,
            ),
      );

      final result = await predictionApi.getGoal(stepGoal);

      verify(mockClient.send(any)).called(1);
      expect(result, stepGoal.toString());
    },

    );
    test('getUser returns an error when status code is not 200', () async {
      when(mockClient.send(any))
          .thenAnswer((_) async => StreamedResponse(Stream.empty(), 404));

      expect(
              () async => await predictionApi.getGoal(stepGoal), throwsA(isA<ApiException>()));
    });

    test('getUser throws SocketException when there is no internet', () async {
      when(mockClient.send(any))
          .thenThrow(const SocketException('Failed host lookup'));

      expect(
              () async => await predictionApi.getGoal(stepGoal), throwsA(isA<ApiException>()));
    });
  }
);
}