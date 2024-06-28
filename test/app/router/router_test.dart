import 'package:flexivity/data/models/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexivity/app/router/router.dart' as router;
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<GoRouterState>()])
import 'router_test.mocks.dart';

void main() {
  group('router guard', () {
    test(
      'router guard Send the user to / when not logged in',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/home');

        router.doRoute(mockState, null);
      },
    );

    test(
      'router guard User can go to /login when not logged in',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/login');

        expectLater(
          router.doRoute(mockState, null),
          completion(null),
        );
      },
    );

    test(
      'router guard User can go to /sign_up when not logged in',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/sign_up');

        expectLater(
          router.doRoute(mockState, null),
          completion(null),
        );
      },
    );

    test(
      'router guard Send the user to /home when the user is logged in and tries to access /',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/');

        expectLater(
          router.doRoute(mockState, Credentials(0, '', '')),
          completion('/home'),
        );
      },
    );

    test(
      'router guard Send the user to requested route when the user is logged in',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/home');

        expectLater(
          router.doRoute(mockState, Credentials(0, '', '')),
          completion(null),
        );
      },
    );

    test(
      'router guard Send the user to /home when route is / and the user is logged in',
      () {
        final mockState = MockGoRouterState();
        when(mockState.matchedLocation).thenReturn('/');

        expectLater(
          router.doRoute(mockState, Credentials(0, '', '')),
          completion('/home'),
        );
      },
    );
  });
}
