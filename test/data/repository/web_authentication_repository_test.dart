import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/new_user.dart';
import 'package:flexivity/data/models/responses/login_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/remote/authentication/web_authentication_api.dart';
import 'package:flexivity/data/repositories/authentication/web_authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<WebAuthenticationApi>()])
import 'web_authentication_repository_test.mocks.dart';

void main() {
  var api = MockWebAuthenticationApi();
  var apiException = const ApiException('Test');
  var user = User(0, '', '', '', '', '');
  var newUser = NewUser(0, '', '', '', '', '', '');
  var loginResponse = LoginResponse(user, '', '');

  test('It can call the api register method', () async {
    var repo = WebAuthenticationRepository(api: api);
    when(api.register(any)).thenAnswer((_) => Future.value(null));
    expect(() async => await repo.register(newUser), returnsNormally);
  });

  test('Register throws ApiException', () async {
    var repo = WebAuthenticationRepository(api: api);
    when(api.register(any)).thenAnswer((_) => Future.error(apiException));
    expect(() => repo.register(newUser), throwsA(isA<ApiException>()));
  });

  test('It can successfully call the api login method', () async {
    var repo = WebAuthenticationRepository(api: api);
    when(api.login(any, any)).thenAnswer(
      (_) => Future.value(loginResponse),
    );
    expect(await repo.login('test', 'test'), loginResponse);
  });

  test('Login throws ApiException', () async {
    var repo = WebAuthenticationRepository(api: api);
    when(api.login(any, any)).thenAnswer((_) => Future.error(apiException));
    expect(() => repo.login('test', 'test'), throwsA(isA<ApiException>()));
  });

  test('Can automatically populate api object', () {
    var repo = WebAuthenticationRepository();
    expect(repo.api, isNotNull);
  });
}
