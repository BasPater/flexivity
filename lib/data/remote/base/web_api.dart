import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebApi {
  String get host => dotenv.maybeGet('HOST', fallback: '10.0.2.2') as String;
  int get port =>
      int.parse(dotenv.maybeGet('PORT', fallback: '8080') as String);

  /// Gets the full URL to the back-end server
  String getUrl() {
    try {
      Uri.parseIPv4Address(host);
      return '$host:$port';
    } on FormatException {
      if (host == 'localhost') {
        if (defaultTargetPlatform == TargetPlatform.android) {
          return '10.0.2.2:$port';
        }

        return 'localhost:$port';
      }

      return host;
    }
  }
}
