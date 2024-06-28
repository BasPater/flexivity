import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/remote/credentials/abstract_credentials_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalCredentialsApi implements ICredentialsApi {
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const userIdKey = 'user_id';

  final FlutterSecureStorage storage;

  LocalCredentialsApi(this.storage);

  /// Save the credentials to the keystore
  @override
  Future setCredentials(
    int userId,
    String accessToken,
    String refreshToken,
  ) async {
    await storage.write(key: userIdKey, value: userId.toString());
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
  }

  /// Gets the credentials from the keystore
  @override
  Future<Credentials> getCredentials() async {
    String? userId = await storage.read(key: userIdKey);
    String? accessToken = await storage.read(key: accessTokenKey);
    String? refreshToken = await storage.read(key: refreshTokenKey);
    if (userId == null || accessToken == null || refreshToken == null) {
      return Future.error(const ApiException('Credentials don\'t exist'));
    }

    return Credentials(int.parse(userId), accessToken, refreshToken);
  }

  /// Deletes the credentials from the keystore
  /// Essentially logging out the user
  @override
  Future<void> deleteCredentials() async {
    storage.delete(key: userIdKey);
    storage.delete(key: accessTokenKey);
    return storage.delete(key: refreshTokenKey);
  }

  /// Checks if the credentials exist in the keystore
  @override
  Future<bool> hasCredentials() async {
    return await storage.read(key: userIdKey) != null &&
        await storage.read(key: accessTokenKey) != null &&
        await storage.read(key: refreshTokenKey) != null;
  }
}
