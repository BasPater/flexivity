import 'dart:io';

import 'package:flexivity/app/views/friends_view/add_friend/add_friend_view.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/repositories/friend/friend_repository.dart';
import 'package:flexivity/presentation/friends_view_model/add_friend/add_friend_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'add_friend_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FriendRepository>(),
  MockSpec<Globals>(),
  MockSpec<AddFriendViewModel>()
])
void main() {
  MockFriendRepository mockFriendRepository = MockFriendRepository();
  AddFriendViewModel viewModel =
      AddFriendViewModel(friendRepo: mockFriendRepository);
  AddFriendViewModel mockedViewModel = MockAddFriendViewModel();
  late Widget app;

  setUp(() {
    mockFriendRepository = MockFriendRepository();
    viewModel = AddFriendViewModel(friendRepo: mockFriendRepository);
    app = MaterialApp(
      home: Scaffold(body: AddFriendContent(viewModel: mockedViewModel)),
    );
  });

  testWidgets('AddFriendViewModel renders correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: AddFriendViewModel(friendRepo: mockFriendRepository),
    ));

    // Verify that AddFriendViewModel is shown.
    expect(find.byType(AddFriendViewModel), findsOneWidget);
  });

  group('addFriend', () {
    test('addFriend should work', () async {
      when(mockFriendRepository.addFriend(any)).thenAnswer((_) async => true);
      viewModel.addFriendController.text = "kaas";

      expectLater(viewModel.addFriend(), completes);
    });

    test('addFriend should work', () async {
      when(mockFriendRepository.addFriend(any)).thenAnswer((_) async => false);
      viewModel.addFriendController.text = "kaas";

      expectLater(viewModel.addFriend(), throwsA(isA<ApiException>()));
    });

    test('addFriend should work', () async {
      when(mockFriendRepository.addFriend(any))
          .thenThrow(const SocketException('failed'));
      viewModel.addFriendController.text = "kaas";

      expectLater(viewModel.addFriend(), throwsA(isA<ApiException>()));
    });
  });

  group('UI', () {
    testWidgets('addFriend should work when form is valid',
        (WidgetTester tester) async {
      when(mockedViewModel.addFriend()).thenAnswer((_) async => null);
      when(mockedViewModel.addFriendController)
          .thenReturn(TextEditingController(text: 'kaas'));

      await tester.pumpWidget(app);

      // Find the send request button and tap it
      var sendButton = find.byType(FullWidthButton);
      await tester.tap(sendButton);

      // Rebuild the widget after the state has changed
      await tester.pump();

      // Check if the Snackbar with the success message is shown
      expect(find.text('Request sent successfully!'), findsOneWidget);
    });
  });
}
