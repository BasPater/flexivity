
abstract interface class IPasswordApi {
  Future forgetPassword(String email);
  Future checkPasswordResetCode(String code);
  Future resetPassword(String password, String code);
}