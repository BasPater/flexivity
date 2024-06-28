import 'package:flexivity/data/models/credentials.dart';

abstract interface class ICredentialsRepository {
  Future<void> setCredentials(int userId, String accessToken, String refreshToken);
  Future<Credentials> getCredentials();
  Future<void> deleteCredentials();
  Future<bool> hasCredentials();
}
