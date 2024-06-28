import 'package:flexivity/app/views/start_view/start_view.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/remote/activity/web_activity_api.dart';
import 'package:flexivity/data/remote/group/group_api.dart';
import 'package:flexivity/data/remote/prediction/prediction_api.dart';
import 'package:flexivity/data/remote/user/password_api.dart';
import 'package:flexivity/data/remote/health/local_health_api.dart';
import 'package:flexivity/data/remote/friend/friend_api.dart';
import 'package:flexivity/data/remote/user/user_api.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/data/repositories/prediction/prediction_repository.dart';
import 'package:flexivity/data/repositories/preferences/preferences_repository.dart';
import 'package:flexivity/data/repositories/user/password_repository.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/data/repositories/authentication/web_authentication_repository.dart';
import 'package:flexivity/presentation/friends_view_model/add_friend/add_friend_view_model.dart';
import 'package:flexivity/presentation/friends_view_model/friends_view_model.dart';
import 'package:flexivity/presentation/friends_view_model/request_view_model/request_view_model.dart';
import 'package:flexivity/presentation/groups_view_model/group_create_view_model/group_create_view_model.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/add_members_view_model/add_members_view_model.dart';
import 'package:flexivity/presentation/groups_view_model/group_detail_view_model/group_detail_view_model.dart';
import 'package:flexivity/presentation/groups_view_model/group_request_view_model/group_request_view_model.dart';
import 'package:flexivity/presentation/groups_view_model/groups_overview_view_model.dart';
import 'package:flexivity/presentation/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:flexivity/presentation/home_view_model/home_view_model.dart';
import 'package:flexivity/presentation/login_view_model/login_view_model.dart';
import 'package:flexivity/presentation/profile_view_model/change_password_view_model.dart';
import 'package:flexivity/presentation/profile_view_model/profile_view_model.dart';
import 'package:flexivity/presentation/reset_password_view_model/reset_password_step_two_view_model.dart';
import 'package:flexivity/presentation/reset_password_view_model/reset_password_view_model.dart';
import 'package:flexivity/presentation/sign_up_view_model/sign_up_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:health/health.dart';
import 'package:http/http.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../presentation/prediction_view_model/prediction_view_model.dart';

const unGuardedRoutes = [
  r'^/$',
  r'^/login$',
  r'^/sign_up$',
  r'^/forgot_password$',
  r'^/reset_password$',
  r'^/reset_password_step_two/.*$',
];

GoRouter routerConfig({Credentials? credentials}) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            defaultTransition(context, state, const StartScreen()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => defaultTransition(
            context,
            state,
            HomeViewModel(
              healthRepo: HealthRepository(
                LocalHealthApi(Health()),
              ),
              activityRepo: ActivityRepository(WebActivityApi(
                Client(),
                Globals.credentials ?? Credentials(0, '', ''),
              )),
              prefRepo: PreferencesRepository(),
            )),
      ),
      GoRoute(
        path: '/groups',
        pageBuilder: (context, state) => defaultTransition(
          context,
          state,
          GroupOverviewViewModel(
            groupRepo: GroupRepository(
              GroupApi(
                Client(),
                credentials ?? Globals.credentials,
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/groups/create',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => GroupCreateViewModel(
            groupRepo: GroupRepository(
              GroupApi(
                Client(),
                credentials ?? Globals.credentials,
              ),
            ),
            friendRepo: FriendRepository(
              FriendApi(
                Client(),
                credentials ?? Globals.credentials,
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/groups/requests',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => GroupRequestViewModel(
            groupRepo: GroupRepository(
              GroupApi(
                Client(),
                credentials ?? Globals.credentials,
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/groups/add/:groupId',
        pageBuilder: (context, state) => SwipeablePage(
            builder: (context) => AddMembersViewModel(
                  groupRepo: GroupRepository(GroupApi(
                      Client(), Globals.credentials ?? Credentials(0, '', ''))),
                  friendRepo: FriendRepository(FriendApi(
                      Client(), Globals.credentials ?? Credentials(0, '', ''))),
                  groupId: int.parse(state.pathParameters["groupId"] ?? "0"),
                )),
      ),
      GoRoute(
        path: '/groups/:groupId',
        pageBuilder: (context, state) => defaultTransition(
          context,
          state,
          GroupDetailViewModel(
            groupRepo: GroupRepository(GroupApi(Client(), Globals.credentials)),
            groupId: state.pathParameters["groupId"] ?? "",
            groupName: state.extra as String? ?? "",
          ),
        ),
      ),
      GoRoute(
        path: '/friends',
        pageBuilder: (context, state) => defaultTransition(
          context,
          state,
          FriendsViewModel(
            friendRepo:
                FriendRepository(FriendApi(Client(), Globals.credentials!)),
          ),
        ),
      ),
      GoRoute(
        path: '/friends/request',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => RequestViewModel(
            friendRepo:
                FriendRepository(FriendApi(Client(), Globals.credentials!)),
          ),
        ),
      ),
      GoRoute(
        path: '/add_friend',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => AddFriendViewModel(
            friendRepo:
                FriendRepository(FriendApi(Client(), Globals.credentials!)),
          ),
        ),
      ),
      GoRoute(
        path: '/prediction',
        pageBuilder: (context, state) => defaultTransition(
          context,
          state,
          PredictionViewModel(
            predictionRepository: PredictionRepository(PredictionApi(
              Client(),
              Globals.credentials ?? Credentials(0, '', ''),
            )),
            preferencesRepository: PreferencesRepository(),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => ProfileScreenViewModel(
            prefRepo: PreferencesRepository(),
            userRepo: UserRepository(UserApi(Client(), Globals.credentials!)),
            credentialsRepo: CredentialsRepository(),
          ),
        ),
      ),
      GoRoute(
        path: '/sign_up',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => SignUpViewModel(
            authRepo: WebAuthenticationRepository(),
            credentialsRepo: CredentialsRepository(),
          ),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => LoginViewModel(
            authRepo: WebAuthenticationRepository(),
            credentialsRepo: CredentialsRepository(),
          ),
        ),
      ),
      GoRoute(
        path: '/forgot_password',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => ForgotPasswordViewModel(
            passwordRepo: PasswordRepository(
              PasswordApi(
                Client(),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/reset_password',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => ResetPasswordViewModel(
            passwordRepo: PasswordRepository(
              PasswordApi(
                Client(),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/reset_password_step_two/:token',
        pageBuilder: (context, state) => SwipeablePage(
          builder: (context) => ResetPasswordStepTwoViewModel(
            token: state.pathParameters['token']!,
            passwordRepo: PasswordRepository(
              PasswordApi(
                Client(),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/change-password',
        pageBuilder: (context, state) => SwipeablePage(
            builder: (context) => ChangePasswordViewModel(
                  userRepo: UserRepository(
                    UserApi(
                      Client(),
                      credentials ?? Globals.credentials,
                    ),
                  ),
                )),
      )
    ],
    redirect: (context, state) async => doRoute(
      state,
      credentials ?? Globals.credentials,
    ),
  );
}

/// Acts as a route guard
Future<String?> doRoute(GoRouterState state, Credentials? credentials) async {
  if (_isGuarded(state.matchedLocation)) {
    if (credentials == null) {
      return '/';
    }

    return null;
  }

  if (credentials != null && state.matchedLocation == '/') {
    return '/home';
  }

  return null;
}

/// Check if the current route is guarded
bool _isGuarded(String route) {
  return !unGuardedRoutes.any((pattern) => RegExp(pattern).hasMatch(route));
}
