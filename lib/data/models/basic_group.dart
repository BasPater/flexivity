import 'dart:core';

import 'package:flexivity/data/models/user.dart';


class BasicGroup {
  final int groupId;
  final String name;
  final User ownedBy;

  BasicGroup(this.groupId, this.name, this.ownedBy);

  factory BasicGroup.fromJson(Map<String, dynamic> json) {
    return BasicGroup(
      json['groupId'],
      json['name'],
      User.fromJson(json['ownedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'ownedBy': ownedBy.toJson(),
    };
  }
}