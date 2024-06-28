import 'package:flexivity/data/models/errors/api_exception.dart';

class HttpApiException extends ApiException {
  final int statusCode;

  const HttpApiException(super.message, this.statusCode);
}
