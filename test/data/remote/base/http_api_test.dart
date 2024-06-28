import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'http_api_test.mocks.dart';

Stream<List<int>> toUtf8Stream(Object obj) {
  return Stream.value(utf8.encode(jsonEncode(obj)));
}

extension AnswerInOrder on PostExpectation {
  /// Watch out when using this method as there's no error checking
  void thenAnswerInOrder<T>(List<T> answers) {
    final answerQueue = Queue.of(answers);

    thenAnswer((_) async => answerQueue.removeFirst());
  }
}

void main() {
  setUp(() {
    dotenv.testLoad();
  });

  group('get', () {
    test('get Can send request', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, null).get('/test'),
        completion(isA<Response>()),
      );
      verify(mockClient.send(any));
    });

    test('get Can send request with credentials', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).get('/test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(
        request.headers,
        containsPair(HttpHeaders.authorizationHeader, 'Bearer '),
      );
    });

    test('get Can send request with headers', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).get(
          '/test',
          headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
        ),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.headers, hasLength(3));
    });
  });

  group('post', () {
    test('post Can send request without body', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).post('/test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.body, '');
    });

    test('post Can send request with credentials', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).post('test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(
        request.headers,
        containsPair(HttpHeaders.authorizationHeader, 'Bearer '),
      );
    });

    test('post Can send request with headers', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).post(
          '/test',
          headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
        ),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.headers, hasLength(3));
    });

    test(
      'post Can send request with body and adds the Content-Type header',
      () async {
        final mockClient = MockClient();
        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(
            toUtf8Stream({}),
            200,
          ),
        );

        await expectLater(
          HttpApi(mockClient, Credentials(1, '', '')).post(
            '/test',
            headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
            body: jsonEncode({}),
          ),
          completes,
        );

        Request request = verify(mockClient.send(captureAny)).captured[0];
        expect(request.body, isNot(''));
        expect(
          request.headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );
  });

  group('put', () {
    test('put Can send request without body', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).put('/test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.body, '');
    });

    test('put Can send request with credentials', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).put('test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(
        request.headers,
        containsPair(HttpHeaders.authorizationHeader, 'Bearer '),
      );
    });

    test('put Can send request with headers', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).put(
          '/test',
          headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
        ),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.headers, hasLength(3));
    });

    test(
      'put Can send request with body and adds the Content-Type header',
      () async {
        final mockClient = MockClient();
        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(
            toUtf8Stream({}),
            200,
          ),
        );

        await expectLater(
          HttpApi(mockClient, Credentials(1, '', '')).put(
            '/test',
            headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
            body: {'body': 'text'},
          ),
          completes,
        );

        Request request = verify(mockClient.send(captureAny)).captured[0];
        expect(request.body, isNot(''));
        expect(
          request.headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );
  });

  group('delete', () {
    test('delete Can send request without body', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).delete('/test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.body, '');
    });

    test('delete Can send request with credentials', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).delete('test'),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(
        request.headers,
        containsPair(HttpHeaders.authorizationHeader, 'Bearer '),
      );
    });

    test('delete Can send request with headers', () async {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream({}),
          200,
        ),
      );

      await expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).delete(
          '/test',
          headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
        ),
        completes,
      );
      Request request = verify(mockClient.send(captureAny)).captured[0];
      expect(request.headers, hasLength(3));
    });

    test(
      'delete Can send request with body and adds the Content-Type header',
      () async {
        final mockClient = MockClient();
        when(mockClient.send(any)).thenAnswer(
          (_) async => StreamedResponse(
            toUtf8Stream({}),
            200,
          ),
        );

        await expectLater(
          HttpApi(mockClient, Credentials(1, '', '')).delete(
            '/test',
            headers: {HttpHeaders.acceptCharsetHeader: 'utf8'},
            body: 'g'
          ),
          completes,
        );

        Request request = verify(mockClient.send(captureAny)).captured[0];
        expect(request.body, isNot(''));
        expect(
          request.headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );
  });

  group('response handling', () {
    test('response handler throws unauthorized when 401 is returned', () {
      final mockClient = MockClient();
      when(mockClient.send(any)).thenAnswer(
        (_) async => StreamedResponse(
          toUtf8Stream(ErrorResponse('Error', '', DateTime.now())),
          401,
        ),
      );

      expectLater(
        HttpApi(mockClient, Credentials(1, '', '')).post(''),
        throwsA(
          isA<ApiAuthenticationException>().having(
            (e) => e.message,
            'message',
            'Invalid session',
          ),
        ),
      );
    });

    test(
      'response handler correctly refreshes token when 401 is returned with message token expired',
      () {
        final mockClient = MockClient();
        when(mockClient.send(any)).thenAnswerInOrder([
          StreamedResponse(
            toUtf8Stream(ErrorResponse('Token expired', '', DateTime.now())),
            401,
            request: Request('post', Uri.http('example')),
          ),
          StreamedResponse(
            toUtf8Stream({'accessToken': 'token', 'refreshToken': 'token'}),
            200,
          ),
          StreamedResponse(toUtf8Stream({}), 200),
        ]);

        expectLater(
          HttpApi(mockClient, Credentials(1, '', '')).post(''),
          completes,
        );
      },
    );

    test(
      'response handler throws unauthorized when 401 is returned after a token refresh',
      () async {
        final mockClient = MockClient();
        when(mockClient.send(any)).thenAnswerInOrder(
          [
            StreamedResponse(
              toUtf8Stream(ErrorResponse('Token expired', '', DateTime.now())),
              401,
            ),
            StreamedResponse(
              toUtf8Stream(ErrorResponse('Error', '', DateTime.now())),
              401,
            ),
          ],
        );

        expectLater(
          HttpApi(mockClient, Credentials(1, '', '')).post(''),
          throwsA(
            isA<ApiAuthenticationException>().having(
              (e) => e.message,
              'message',
              'Something went wrong refreshing the token',
            ),
          ),
        );
      },
    );
  });

  group('createHttpException', () {
    test('createHttpException can create an exception', () {
      final response = Response(
        jsonEncode(ErrorResponse('Error', '', DateTime.now())),
        200,
      );
      expect(
        HttpApi(MockClient(), null).createHttpException(response, '').message,
        'Error',
      );
    });

    test(
      'createHttpException can create an exception when the response body is empty',
      () {
        final response = Response(
          '',
          200,
        );
        expect(
          HttpApi(MockClient(), null)
              .createHttpException(response, 'Error without body')
              .message,
          'Error without body',
        );
      },
    );

    test(
      'createHttpException can create an exception when the response body is invalid',
      () {
        final response = Response(
          jsonEncode({}),
          200,
        );
        expect(
          HttpApi(MockClient(), null)
              .createHttpException(response, 'Error with invalid body')
              .message,
          'Error with invalid body',
        );
      },
    );
  });
}
