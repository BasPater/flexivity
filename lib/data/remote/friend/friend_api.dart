import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/models/errors/api_exception.dart';
import 'package:flexivity/data/models/requests/delete_friend_request.dart';
import 'package:flexivity/data/models/requests/response_friendship_request.dart';
import 'package:flexivity/data/models/responses/get_friend_request_response.dart';
import 'package:flexivity/data/models/requests/send_friend_request.dart';
import 'package:flexivity/data/models/responses/get_friendships_response.dart';
import 'package:flexivity/data/remote/base/http_api.dart';
import 'package:flexivity/data/remote/friend/abstract_friend_api.dart';
import 'package:http/http.dart';

class FriendApi extends HttpApi implements IFriendApi {
  FriendApi(super.client, super.credentials);

  /// Send an friend invite
  @override
  Future<bool> addFriend(SendFriendRequest request) async {
    Response response = await super.post(
      'api/v1/friends',
      body: request,
    );

    // Check if the request succeeded
    return response.statusCode == HttpStatus.ok;
  }

  /// Remove a friendship between two users
  @override
  Future<bool> deleteFriend(DeleteFriendRequest request) async {
    Response response = await super.delete(
      'api/v1/friends',
      body: request,
    );
    // Check if the request succeeded
    return response.statusCode == HttpStatus.ok;
  }

  /// Get the friends by userId
  @override
  Future<GetFriendshipResponse> getFriends(int id) async {
    Response response = await super.post(
      'api/v1/friends/retrieve',
      body: {
        'userId': id,
      },
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving friends, status: ${response.statusCode}.',
      ));
    }

    return GetFriendshipResponse.fromJson(jsonDecode(response.body));
  }

  /// Get the pending friend requests by userId
  @override
  Future<GetFriendRequestResponse> getFriendRequests(int id) async {
    Response response = await super.post(
      'api/v1/friends/requests',
      body: {
        'userId': id,
      },
    );
    // Check if the request succeeded
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(ApiException(
        'Error retrieving friend requests, status: ${response.statusCode}.',
      ));
    }
    return GetFriendRequestResponse.fromJson(jsonDecode(response.body));
  }

  /// Update the pending friend request
  @override
  Future<bool> respondFriendRequest(ResponseFriendshipRequest request) async {
    Response response = await super.put(
      'api/v1/friends',
      body: request,
    );
    return response.statusCode == HttpStatus.ok;
  }
}
