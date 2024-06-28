import 'dart:convert';

import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/remote/activity/web_activity_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../authentication/web_authentication_api_test.dart';
@GenerateNiceMocks([MockSpec<Client>()])
import 'web_activity_api_test.mocks.dart';

void main() {
  final testActivity = Activity(0, 1, 50, DateTime(2030));

  group('getActivity', () {
    test('getActivity is not implemented', () async {
      expect(
        () => WebActivityApi(MockClient(), const Credentials(0, '', ''))
            .getActivity(0),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('getActivities', () {
    test('getActivities completes normally', () async {
      dotenv.testLoad();

      final client = MockClient();
      when(
        client.send(any),
      ).thenAnswer(
        (_) async => StreamedResponse(
          Stream.value(utf8.encode(jsonEncode([testActivity.toJson()]))),
          200,
        ),
      );

      expectLater(
        WebActivityApi(client, const Credentials(0, '', ''))
            .getActivities(0, 0, 1),
        completion(isA<List<Activity>>()),
      );
    });

    test(
        'getActivities throws ApiAuthenticationException when a forbidden status is returned',
        () async {
      dotenv.testLoad();

      final client = MockClient();
      when(
        client.send(any),
      ).thenAnswer(
        (_) async => StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode(ErrorResponse('message', '', DateTime.now())),
            ),
          ),
          401,
        ),
      );

      expect(
        () => WebActivityApi(client, const Credentials(0, '', ''))
            .getActivities(0, 0, 1),
        throwsA(
          isA<ApiAuthenticationException>().having(
            (e) => e.message,
            'message',
            contains('Invalid session'),
          ),
        ),
      );
    });

    test(
      'getActivities throws ApiException when a non ok status is returned',
      () {
        dotenv.testLoad();

        final client = MockClient();
        when(
          client.send(any),
        ).thenAnswer(
          (_) async => StreamedResponse(
            Stream.value(
              utf8.encode(
                jsonEncode(
                  ErrorResponse('No activities found', 't', DateTime.now()),
                ),
              ),
            ),
            404,
          ),
        );

        expect(
          () => WebActivityApi(client, const Credentials(0, '', ''))
              .getActivities(0, 0, 1),
          throwsA(isA<ApiException>().having(
            (e) => e.message,
            'message',
            'No activities found',
          )),
        );
      },
    );
  });

  group('saveActivity', () {
    test('saveActivity can save activity', () {
      dotenv.testLoad();

      final client = MockClient();
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(Activity(0, 0, 0, DateTime.now())),
          200,
        ),
      );

      expectLater(
        WebActivityApi(client, const Credentials(0, '', '')).saveActivity(
          Activity(0, 0, 0, DateTime.now()),
        ),
        completes,
      );
    });

    test('saveActivity throws error on non 200 status codes', () {
      dotenv.testLoad();

      final client = MockClient();
      when(client.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Error while saving activity', '', DateTime.now())),
          500,
        ),
      );

      expect(
        () => WebActivityApi(client, const Credentials(0, '', '')).saveActivity(
          Activity(0, 0, 0, DateTime.now()),
        ),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Error while saving activity',
        )),
      );
    });
  });
}
