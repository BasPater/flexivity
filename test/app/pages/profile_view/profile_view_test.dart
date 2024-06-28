import 'dart:io';

import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/profile_view/profile_view.dart';
import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/responses/get_user_response.dart';
import 'package:flexivity/data/models/user.dart';
import 'package:flexivity/data/repositories/credentials/credentials_repository.dart';
import 'package:flexivity/data/repositories/preferences/preferences_repository.dart';
import 'package:flexivity/data/repositories/user/user_repository.dart';
import 'package:flexivity/presentation/profile_view_model/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<PreferencesRepository>(),
  MockSpec<CredentialsRepository>(),
  MockSpec<ProfileScreenViewModel>(),
  MockSpec<GoRouter>()
])
void main() {
  final userRepo = MockUserRepository();
  final prefRepo = MockPreferencesRepository();
  final credentialsRepo = MockCredentialsRepository();
  final stubbedViewModel = MockProfileScreenViewModel();
  var mockRouter = MockGoRouter();

  setUp(() {
    reset(userRepo);
    reset(prefRepo);
    reset(credentialsRepo);
    reset(stubbedViewModel);
  });

  User testUser = User(
      1, // userId
      'test@email.com', // email
      'testUser', // userName
      'Test', // firstName
      'User', // lastName
      'admin' // role
      );

  test('getUser when user is loaded into Globals', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    Globals.user = User(0, '', '', '', '', '');
    await viewModel.getUser();
    expect(viewModel.user, Globals.user);
    Globals.user = null;
  });

  test('getUser when no user is loaded into Globals', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    Globals.user = null;
    await viewModel.getUser();
    expect(viewModel.uiState, UIState.error);
  });

  test('deleteUser', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    when(userRepo.deleteUser(testUser.userId)).thenAnswer((_) async => null);

    viewModel.user = testUser;

    await viewModel.deleteUser();

    verify(userRepo.deleteUser(testUser.userId)).called(1);
  });

  test('deleteUser user is null', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    when(userRepo.deleteUser(any)).thenAnswer((_) async => null);

    expect(viewModel.deleteUser(), throwsA(isA<Exception>()));
  });

  test('updateUser', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );
    final testUser =
        User(1, 'test@example.com', 'testuser', 'Test', 'User', 'admin');
    when(userRepo.updateUser(any))
        .thenAnswer((_) async => GetUserResponse(testUser));

    viewModel.user = testUser;

    await viewModel.updateUser();

    verify(userRepo.updateUser(any)).called(1);
  });

  test('updateUser user is null', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    when(userRepo.updateUser(any))
        .thenThrow(SocketException('Failed host lookup'));

    expect(viewModel.updateUser(), throwsA(isA<Exception>()));
  });

  test('logout', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    when(credentialsRepo.deleteCredentials()).thenAnswer((_) async {});

    await viewModel.logout();

    verify(credentialsRepo.deleteCredentials()).called(1);
  });

  test('setStepGoal', () async {
    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    when(prefRepo.setStepGoal('10000')).thenAnswer((_) async {});

    viewModel.stepGoalController.text = '10000';
    viewModel.setStepGoal();

    verify(prefRepo.setStepGoal('10000')).called(1);
  });

  test('ProfileScreenViewModel test', () async {
    when(credentialsRepo.getCredentials())
        .thenAnswer((_) async => const Credentials(1, 'cheese', 'cheese'));
    when(prefRepo.getStepGoal()).thenAnswer((_) async => '10000');

    final viewModel = ProfileScreenViewModel(
      userRepo: userRepo,
      prefRepo: prefRepo,
      credentialsRepo: credentialsRepo,
    );

    await viewModel.getUser();
    await viewModel.getStepGoal();

    verify(prefRepo.getStepGoal()).called(1);
  });

  testWidgets('_Content widget test', (WidgetTester tester) async {
    when(stubbedViewModel.user).thenReturn(testUser);
    when(stubbedViewModel.stepGoalController)
        .thenReturn(TextEditingController(text: '10000'));

    await tester.pumpWidget(MaterialApp(
      home: ProfileContent(viewModel: stubbedViewModel),
    ));

    expect(find.text('${testUser.firstName} ${testUser.lastName}'),
        findsOneWidget);
    expect(find.text('Username: ${testUser.userName}'), findsOneWidget);
    expect(find.text('10000 steps'), findsOneWidget);
  });

  testWidgets('ProfileScreenState widget test', (WidgetTester tester) async {
    when(credentialsRepo.getCredentials())
        .thenAnswer((_) async => const Credentials(1, 'cheese', 'cheese'));
    when(userRepo.getUser(any))
        .thenAnswer((_) async => GetUserResponse(testUser));
    when(stubbedViewModel.getUser()).thenAnswer((_) async {});
    when(stubbedViewModel.getStepGoal()).thenAnswer((_) async {});
    when(stubbedViewModel.uiState).thenReturn(UIState.normal);

    await tester.pumpWidget(MaterialApp(
      home: ProfileScreenViewModel(
        userRepo: userRepo,
        prefRepo: prefRepo,
        credentialsRepo: credentialsRepo,
      ),
    ));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(NavbarWidget), findsOneWidget);
  });

  testWidgets('onTap functions on ProfileContent page',
      (WidgetTester tester) async {
    when(stubbedViewModel.user).thenReturn(testUser);
    when(stubbedViewModel.stepGoalController)
        .thenReturn(TextEditingController(text: '10000'));
    when(stubbedViewModel.user).thenReturn(testUser);
    when(stubbedViewModel.stepGoalController)
        .thenReturn(TextEditingController(text: '10000'));
    when(stubbedViewModel.firstNameController)
        .thenReturn(TextEditingController(text: 'First'));
    when(stubbedViewModel.lastNameController)
        .thenReturn(TextEditingController(text: 'Last'));
    when(stubbedViewModel.deleteAccountController)
        .thenReturn(TextEditingController(text: 'CONFIRM'));
    when(stubbedViewModel.updateUser()).thenAnswer((_) async => null);
    when(stubbedViewModel.deleteUser()).thenAnswer((_) async => null);
    when(stubbedViewModel.logout()).thenAnswer((_) async => null);
    when(stubbedViewModel.setStepGoal()).thenAnswer((_) async => null);

    when(mockRouter.go(any)).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProfileContent(
          viewModel: stubbedViewModel,
        ),
      ),
    ));

    // Find the widget that you want to tap on.
    var editProfileTile = find.widgetWithText(ListTile, 'Edit Profile');
    var deleteAccountTile = find.widgetWithText(ListTile, 'Delete account');
    var logOutTile = find.widgetWithText(ListTile, 'Log out');
    var setStepGoalTile = find.widgetWithText(ListTile, 'Set step goal');

    // Tap on the widget and then trigger a frame.
    await tester.tap(editProfileTile);
    await tester.pump();
    // Verify that the onTap function has been called.
    expect(find.text('Edit your profile'), findsOneWidget);

    var closeEditProfile = find.widgetWithText(TextButton, 'Save');
    await tester.tap(closeEditProfile);
    await tester.pump();

    await tester.tap(deleteAccountTile);
    await tester.pump();
    expect(find.text('CONFIRM'), findsOneWidget);

    var closeDeleteAccount = find.widgetWithText(TextButton, 'Delete');
    await tester.tap(closeDeleteAccount);
    await tester.pump();

    await tester.tap(logOutTile);
    await tester.pump();
    expect(find.text('Yes, log out'), findsOneWidget);

    var closeLogOutProfile = find.widgetWithText(TextButton, 'Cancel');
    await tester.tap(closeLogOutProfile);
    await tester.pump();

    await tester.tap(setStepGoalTile);
    await tester.pump();
    expect(find.text('Cancel'), findsOneWidget);
  });
}
