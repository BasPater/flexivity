
abstract interface class IPasswordRepository {
  Future<bool> forgetPassword(String email);
  Future<bool> checkPasswordResetCode(String code);
  Future<bool> resetPassword(String password, String code);
}