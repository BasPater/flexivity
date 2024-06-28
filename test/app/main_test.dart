import 'package:flexivity/app/views/error_view/error_view.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/models/basic_group.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_disconnected_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/data/models/friendship_status.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/responses/get_group_invites.dart';
import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/main.dart' as appMain;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CredentialsRepository>(),
  MockSpec<ActivityRepository>(),
  MockSpec<HealthRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<FriendRepository>(),
  MockSpec<GroupRepository>(),
])
import 'main_test.mocks.dart';

void main() {
  tearDown(() {
    Globals.credentials = null;
    Globals.friendNotificationsCount = 0;
    Globals.user = null;
  });

  group('initApp', () {
    MockActivityRepository? mockActivityRepo;
    MockCredentialsRepository? mockCredRepo;
    MockHealthRepository? mockHealthRepo;
    MockUserRepository? mockUserRepo;
    MockFriendRepository? mockFriendRepo;
    MockGroupRepository? mockGroupRepo;

    setUp(() {
      mockActivityRepo = MockActivityRepository();
      mockCredRepo = MockCredentialsRepository();
      mockHealthRepo = MockHealthRepository();
      mockUserRepo = MockUserRepository();
      mockFriendRepo = MockFriendRepository();
      mockGroupRepo = MockGroupRepository();

      appMain.defaultActivityRepo = mockActivityRepo;
      appMain.defaultCredRepo = mockCredRepo;
      appMain.defaultHealthRepo = mockHealthRepo;
      appMain.defaultUserRepo = mockUserRepo;
      appMain.defaultFriendRepo = mockFriendRepo;
      appMain.defaultGroupRepo = mockGroupRepo;
      Globals.user = null;
      Globals.credentials = null;
    });

    test('Can load initial data', () async {
      dotenv.testLoad();
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockUserRepo!.getUser(any)).thenAnswer(
        (_) async => GetUserResponse(User(0, '', '', '', '', '')),
      );

      await appMain.initApp();
      verify(mockUserRepo!.getUser(any)).called(1);
    });

    test(
      'Friend request notification count can be set',
      () async {
        dotenv.testLoad();
        when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);
        when(mockCredRepo!.getCredentials()).thenAnswer(
          (_) async => Credentials(0, '', ''),
        );

        when(mockUserRepo!.getUser(any)).thenAnswer(
          (_) async => GetUserResponse(User(0, '', '', '', '', '')),
        );

        when(mockFriendRepo!.getFriendRequests(any)).thenAnswer(
          (_) async => GetFriendRequestResponse(
            [
              FriendRequest(
                actionUserId: 0,
                createdAt: DateTime.now(),
                friend: User(0, '', '', '', '', ''),
                friendshipId: 0,
                status: FriendshipStatus.pending,
                updatedAt: DateTime.now(),
              ),
            ],
          ),
        );

        await appMain.initApp();
        expect(Globals.friendNotificationsCount, 1);
      },
    );

    test('Group request notifications can be set', () async {
      dotenv.testLoad();
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);
      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockUserRepo!.getUser(any)).thenAnswer(
        (_) async => GetUserResponse(User(0, '', '', '', '', '')),
      );

      when(mockGroupRepo!.getGroupInvites()).thenAnswer(
        (_) async => [
          GetGroupInvitesResponse(
            BasicGroup(0, '', User(0, '', '', '', '', '')),
            User(0, '', '', '', '', ''),
          ),
        ],
      );

      await appMain.initApp();
      expect(Globals.groupNotificationsCount, 1);
    });

    test('Can save todays activity when found', () async {
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockHealthRepo!.getTodaysActivity()).thenAnswer(
        (_) async => Activity(0, 0, 0, DateTime.now()),
      );

      when(mockUserRepo!.getUser(any)).thenAnswer(
        (_) async => GetUserResponse(User(0, '', '', '', '', '')),
      );

      await appMain.initApp();
      verify(mockActivityRepo!.saveActivity(any)).called(1);
    });

    test(
      'User is considered logged out when no credentials are found',
      () async {
        when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => false);
        await appMain.initApp();
        expect(Globals.credentials, null);
        expect(Globals.user, null);
      },
    );

    test(
      'User is considered logged out when the user is not logged in or the token is expired',
      () async {
        when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

        when(mockCredRepo!.getCredentials()).thenAnswer(
          (_) async => Credentials(0, '', ''),
        );

        when(mockHealthRepo!.getTodaysActivity()).thenAnswer(
          (_) async => Activity(0, 0, 0, DateTime.now()),
        );

        when(mockActivityRepo!.saveActivity(any)).thenThrow(
          ApiAuthenticationException(''),
        );

        await appMain.initApp();
        expect(Globals.credentials, null);
        expect(Globals.user, null);
      },
    );

    test('An exception is thrown when an ApiException is thrown', () {
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockHealthRepo!.getTodaysActivity()).thenAnswer(
        (_) async => Activity(0, 0, 0, DateTime.now()),
      );

      when(mockActivityRepo!.saveActivity(any)).thenThrow(
        ApiException('Could not save activity'),
      );

      expectLater(
        appMain.initApp(),
        throwsA('Could not save activity'),
      );
    });

    test('Gives correct error message on unhandled exception', () async {
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockHealthRepo!.getTodaysActivity()).thenThrow(Exception());

      await expectLater(appMain.initApp(), throwsA('Something went wrong'));
    });
  });

  group('MyApp view', () {
    MockActivityRepository? mockActivityRepo;
    MockCredentialsRepository? mockCredRepo;
    MockHealthRepository? mockHealthRepo;
    MockUserRepository? mockUserRepo;

    setUp(() {
      mockActivityRepo = MockActivityRepository();
      mockCredRepo = MockCredentialsRepository();
      mockHealthRepo = MockHealthRepository();
      mockUserRepo = MockUserRepository();

      appMain.defaultActivityRepo = mockActivityRepo;
      appMain.defaultCredRepo = mockCredRepo;
      appMain.defaultHealthRepo = mockHealthRepo;
      appMain.defaultUserRepo = mockUserRepo;
      Globals.user = null;
      Globals.credentials = null;
    });

    testWidgets(
      'MyApp shows error view when an error occurred',
      (tester) async {
        when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

        when(mockCredRepo!.getCredentials()).thenAnswer(
          (_) async => Credentials(0, '', ''),
        );

        when(mockHealthRepo!.getTodaysActivity()).thenAnswer(
          (_) async => Activity(0, 0, 0, DateTime.now()),
        );

        when(mockActivityRepo!.saveActivity(any)).thenThrow(
          ApiDisconnectedException('Disconnected'),
        );

        await tester
            .pumpWidget(appMain.MyApp(routerConfig: GoRouter(routes: [])));
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate((widget) => widget is ErrorView),
          findsOne,
        );
        expect(find.text('Disconnected'), findsOne);
      },
    );

    testWidgets('MyApp shows router', (tester) async {
      dotenv.testLoad();
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockUserRepo!.getUser(any)).thenAnswer(
        (_) async => GetUserResponse(User(0, '', '', '', '', '')),
      );

      await tester
          .pumpWidget(appMain.MyApp(routerConfig: GoRouter(routes: [])));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
            (widget) => widget is LoadingView || widget is ErrorView),
        findsNothing,
      );
    });

    testWidgets('MyApp can refresh after an error occurred', (tester) async {
      when(mockCredRepo!.hasCredentials()).thenAnswer((_) async => true);

      when(mockCredRepo!.getCredentials()).thenAnswer(
        (_) async => Credentials(0, '', ''),
      );

      when(mockHealthRepo!.getTodaysActivity()).thenAnswer(
        (_) async => Activity(0, 0, 0, DateTime.now()),
      );

      when(mockActivityRepo!.saveActivity(any)).thenThrow(
        ApiDisconnectedException('Disconnected'),
      );

      when(mockUserRepo!.getUser(any)).thenAnswer(
        (_) async => GetUserResponse(User(0, '', '', '', '', '')),
      );

      await tester
          .pumpWidget(appMain.MyApp(routerConfig: GoRouter(routes: [])));
      await tester.pumpAndSettle();

      reset(mockActivityRepo);

      final button = find.byWidgetPredicate(
        (widget) => widget is FullWidthButton,
      );

      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(Globals.user, isNotNull);
      expect(Globals.credentials, isNotNull);
    });
  });
}
