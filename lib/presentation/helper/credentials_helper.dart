import 'package:flexivity/data/globals.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';

Future<void> logOut(ICredentialsRepository credRepo) async {
  Globals.credentials = null;
  Globals.user = null;
  credRepo.deleteCredentials();
}
