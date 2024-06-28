import 'package:flexivity/app/models/ui_state.dart';
import 'package:flexivity/app/views/empty_view/empty_view.dart';
import 'package:flexivity/app/views/loading_view/loading_view.dart';
import 'package:flexivity/app/widgets/ui_state_switcher/ui_state_switcher.dart';
import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/friend_request.dart';
import 'package:flexivity/presentation/friends_view_model/request_view_model/request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RequestScreen extends State<RequestViewModel> {
  @override
  void initState() {
    widget.getFriendRequests().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Friend requests"),
          leading: IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: UIStateSwitcher(
          uiState: widget.uiState,
          normalState: RequestContent(
            viewModel: widget,
          ),
          loadingState: LoadingView(),
          emptySate: EmptyView(
            iconData: Icons.mail_outlined,
            text: 'It looks like you don\'t have any friend requests.',
            buttonText: 'Refresh',
            onPressed: () async {
              setState(() {
                widget.uiState = UIState.loading;
              });
              await widget.getFriendRequests().then((value) => setState(() {}));
            },
          ),
        ));
  }
}

class RequestContent extends StatefulWidget {
  final RequestViewModel viewModel;

  const RequestContent({super.key, required this.viewModel});

  @override
  State<RequestContent> createState() => RequestContentState();
}

class RequestContentState extends State<RequestContent> {
  Future updateFriend(bool answer, FriendRequest user) async {
    try {
      await widget.viewModel.respondFriendRequest(answer, user);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((error as ApiException).message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          return widget.viewModel
              .getFriendRequests()
              .then((value) => setState(() {}));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
              itemCount: widget.viewModel.requests.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.viewModel.requests[index].friend.firstName} ${widget.viewModel.requests[index].friend.lastName}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                  'Requested at: ${DateFormat('MMMM dd yyyy').format(widget.viewModel.requests[index].createdAt)}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => updateFriend(
                                      true, widget.viewModel.requests[index]),
                                  icon: Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                              IconButton(
                                  onPressed: () => updateFriend(
                                      false, widget.viewModel.requests[index]),
                                  icon: Icon(Icons.close,
                                      color:
                                          Theme.of(context).colorScheme.error)),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                );
              }),
        ));
  }
}
