import 'package:flexivity/data/remote/base/web_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test if getUrl returns a correctly formatted URL', () {
    dotenv.testLoad();
    expect(WebApi().getUrl(), "10.0.2.2:8080");
    dotenv.env.clear();
  });

  test(
    'Test if getUrl returns a correctly formatted URL when using localhost as HOST',
    () {
      // Set platform to IOS
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      dotenv.testLoad();
      dotenv.env.addAll(
        {'HOST': 'localhost', 'PORT': '8080'},
      );
      expect(WebApi().getUrl(), "localhost:8080");
      dotenv.env.clear();

      // Reset platform
      debugDefaultTargetPlatformOverride = null;
    },
  );

  test(
    'Test if getUrl returns a correctly formatted URL when using localhost as HOST on Android',
    () {
      // Set platform to android
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      dotenv.testLoad();
      dotenv.env.addAll(
        {'HOST': 'localhost', 'PORT': '8080'},
      );
      expect(WebApi().getUrl(), "10.0.2.2:8080");
      dotenv.env.clear();

      // Reset platform
      debugDefaultTargetPlatformOverride = null;
    },
  );

  test(
    'Test if getUrl returns a correctly formatted URL when using a domain as HOST',
    () {
      dotenv.testLoad();
      dotenv.env.addAll(
        {'HOST': 'www.google.com', 'PORT': '8080'},
      );
      expect(WebApi().getUrl(), "www.google.com");
      dotenv.env.clear();
    },
  );
}
