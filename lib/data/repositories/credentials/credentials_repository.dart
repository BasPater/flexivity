import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/remote/credentials/abstract_credentials_api.dart';
import 'package:flexivity/data/remote/credentials/local_credentials_api.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsRepository implements ICredentialsRepository {
  final ICredentialsApi api;

  CredentialsRepository({ICredentialsApi? api})
      : api = api ?? LocalCredentialsApi(const FlutterSecureStorage());

  /// Calls setCredentials in the API
  @override
  Future setCredentials(int userId, String accessToken, String refreshToken) {
    return api.setCredentials(userId, accessToken, refreshToken);
  }

  /// Calls getCredentials in the API
  @override
  Future<Credentials> getCredentials() {
    return api.getCredentials();
  }

  /// Calls deleteCredentials in the api
  @override
  Future<void> deleteCredentials() {
    return api.deleteCredentials();
  }

  /// Calls hasCredentials in the API
  @override
  Future<bool> hasCredentials() {
    return api.hasCredentials();
  }
}
