import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/presentation/friends_view_model/add_friend/add_friend_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/full_width_button.dart';

class AddFriendScreen extends State<AddFriendViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Add Friend'),
        ),
        body: AddFriendContent(
          viewModel: widget,
        ));
  }
}

class AddFriendContent extends StatefulWidget {
  final AddFriendViewModel viewModel;

  const AddFriendContent({super.key, required this.viewModel});

  @override
  State<AddFriendContent> createState() => _AddFriendContentState();
}

class _AddFriendContentState extends State<AddFriendContent> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  Future addFriend() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.viewModel.uiState = UIState.loading;
      });
      await widget.viewModel.addFriend().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')));
        try {
          GoRouter.of(context).pop();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (e.toString()),
              ),
            ),
          );
        }
      }).onError((error, stackTrace) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((error as ApiException).message),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Send a friend request by typing the username of your friend. They can find their username by going to the profile page.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Form(
              key: _formKey,
              child: TextFormField(
                controller: widget.viewModel.addFriendController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Username cannot be empty.";
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "Username"),
                autofocus: true,
                focusNode: focusNode,
                onEditingComplete: () async {
                  await addFriend();
                },
                textInputAction: TextInputAction.send,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FullWidthButton(
                isLoading: widget.viewModel.uiState == UIState.loading,
                label: "Send Request",
                onPressed: () async {
                  await addFriend();
                }),
          ),
        ],
      ),
    );
  }
}
