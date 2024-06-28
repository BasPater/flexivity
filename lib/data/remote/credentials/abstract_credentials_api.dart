import 'package:flexivity/data/models/credentials.dart';

abstract interface class ICredentialsApi {
  Future setCredentials(int userId, String accessToken, String refreshToken);
  Future<Credentials> getCredentials();
  Future<void> deleteCredentials();
  Future<bool> hasCredentials();
}
