import 'dart:async';
import 'package:flexivity/app/router/router.dart';
import 'package:flexivity/app/theme/app_theme.dart';
import 'package:flexivity/app/views/error_view/error_view.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/remote/activity/web_activity_api.dart';
import 'package:flexivity/data/remote/credentials/local_credentials_api.dart';
import 'package:flexivity/data/remote/friend/friend_api.dart';
import 'package:flexivity/data/remote/group/group_api.dart';
import 'package:flexivity/data/remote/health/local_health_api.dart';
import 'package:flexivity/data/remote/user/user_api.dart';
import 'package:flexivity/data/repositories/activity/activity_repository.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/data/repositories/group/group_repository.dart';
import 'package:flexivity/data/repositories/health/health_repository.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/domain/repositories/activity/abstract_activity_repository.dart';
import 'package:flexivity/domain/repositories/credentials/abstract_credentials_repository.dart';
import 'package:flexivity/domain/repositories/friend/abstract_friend_repository.dart';
import 'package:flexivity/domain/repositories/group_repository/abstract_group_repository.dart';
import 'package:flexivity/domain/repositories/health/abstract_health_repository.dart';
import 'package:flexivity/domain/repositories/user/abstract_user_repository.dart';
import 'package:flexivity/domain/service/activity_background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

ICredentialsRepository? defaultCredRepo;
IActivityRepository? defaultActivityRepo;
IHealthRepository? defaultHealthRepo;
IUserRepository? defaultUserRepo;
IFriendRepository? defaultFriendRepo;
IGroupRepository? defaultGroupRepo;

void main() {
  dotenv.load().then((_) {
    ActivityBackgroundService(workmanager: Workmanager()).start();
    runApp(MyApp(routerConfig: routerConfig()));
  });
}

class MyApp extends StatefulWidget {
  final RouterConfig<Object> routerConfig;

  const MyApp({super.key, required this.routerConfig});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexivityAppTheme.buildLightTheme(),
      darkTheme: FlexivityAppTheme.buildDarkTheme(),
      debugShowCheckedModeBanner: false,
      title: 'Flexivity',
      home: Scaffold(
        body: FutureBuilder(
          future: initApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorView(
                text: snapshot.error.toString(),
                optionalWidget: FullWidthButton(
                  label: 'Retry',
                  onPressed: () {
                    setState(() {});
                  },
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp.router(
                theme: FlexivityAppTheme.buildLightTheme(),
                darkTheme: FlexivityAppTheme.buildDarkTheme(),
                debugShowCheckedModeBanner: false,
                routerConfig: widget.routerConfig,
              );
            } else {
              return LoadingView();
            }
          },
        ),
      ),
    );
  }
}

/// Loads the user's credentials
Future<Credentials?> loadCredentials() async {
  final credRepo = defaultCredRepo ??
      CredentialsRepository(
        api: LocalCredentialsApi(FlutterSecureStorage()),
      );

  if (!await credRepo.hasCredentials()) {
    return null;
  }

  return await credRepo.getCredentials();
}

/// Initializes app data
Future<void> initApp() async {
  Credentials? credentials = await loadCredentials();
  if (credentials == null) {
    return;
  }

  Globals.credentials = credentials;

  // Initialize repositories
  final healthRepo =
      defaultHealthRepo ?? HealthRepository(LocalHealthApi(Health()));

  final userRepo =
      defaultUserRepo ?? UserRepository(UserApi(Client(), credentials));

  final activityRepo = defaultActivityRepo ??
      ActivityRepository(WebActivityApi(Client(), credentials));

  final friendRepo =
      defaultFriendRepo ?? FriendRepository(FriendApi(Client(), credentials));

  final groupRepo =
      defaultGroupRepo ?? GroupRepository(GroupApi(Client(), credentials));

  try {
    // Save todays activity if it exists
    final todaysActivity = await healthRepo.getTodaysActivity();
    if (todaysActivity != null) {
      activityRepo.saveActivity(todaysActivity);
    }

    await friendRepo.getFriendRequests(credentials.userId).then((response) {
      Globals.friendNotificationsCount = response.list.length;
    }).catchError((_) async {
      Globals.friendNotificationsCount = 0;
    });

    await groupRepo.getGroupInvites().then((response) {
      Globals.groupNotificationsCount = response.length;
    }).catchError((_) {
      Globals.groupNotificationsCount = 0;
    });

    Globals.user = (await userRepo.getUser(credentials.userId)).user;
  } on ApiAuthenticationException {
    Globals.credentials = null;
    return;
  } on ApiException catch (e) {
    return Future.error(e.message);
  } on Exception {
    return Future.error('Something went wrong');
  }
}
