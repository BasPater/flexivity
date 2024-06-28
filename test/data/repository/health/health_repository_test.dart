import 'package:flexivity/data/remote/health/local_health_api.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'health_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocalHealthApi>()])

void main() {
  group('getTodaysHealthData', () {
    test(
      'saveActivity completes normally',
      () async {
        await expectLater(
          HealthRepository(MockLocalHealthApi()).getTodaysActivity(),
          completes,
        );
      },
    );
  });
}