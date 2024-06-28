import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/groups_view/group_create/friend_list_create_group.dart';
import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/presentation/groups_view_model/group_create_view_model/group_create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupCreateScreen extends State<GroupCreateViewModel> {
  @override
  void initState() {
    widget.getFriendsById().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create group'),
      ),
      body: GroupCreateContent(
        viewModel: widget,
      ),
    );
  }
}

class GroupCreateContent extends StatefulWidget {
  final GroupCreateViewModel viewModel;

  const GroupCreateContent({super.key, required this.viewModel});

  @override
  State<GroupCreateContent> createState() => _GroupCreateContentState();
}

class _GroupCreateContentState extends State<GroupCreateContent> {
  final _formKey = GlobalKey<FormState>();

  Future createGroup() async {
    bool isGroupListEmpty = widget.viewModel.newGroupMemberList.length == 0;

    if (!_formKey.currentState!.validate() || isGroupListEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'The group name cannot be empty and you must select one member for the group.')),
      );
      return;
    }

    setState(() {
      widget.viewModel.uiStateCreateGroup = UIState.loading;
    });

    try {
      await widget.viewModel.createGroup().then((value) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Group created successfully. And the friends you added are also invited.')),
        );
        context.pop();
      });
    } catch (e) {
      setState(() {});
      if (e is ApiException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text((e).message)));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong with the router'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(''),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name of the group:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "The group name cannot be empty";
                            }
                            return null;
                          },
                          controller: widget.viewModel.groupNameController,
                          decoration: const InputDecoration(
                              hintText: "For example: baseball group"),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Add some friends to your group:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                FriendListCreateGroup(viewModel: widget.viewModel),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 7,
                    offset: Offset(0, -3), // changes position of shadow
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.surface,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: FullWidthButton(
                  isLoading:
                      widget.viewModel.uiStateCreateGroup == UIState.loading,
                  label: 'Create group',
                  onPressed: () async {
                    await createGroup();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
