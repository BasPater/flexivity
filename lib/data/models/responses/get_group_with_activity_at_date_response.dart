import '../basic_group.dart';
import '../member.dart';

class GetGroupWithActivityAtDateResponse{
  final BasicGroup group;
  final List<Member> members;

  GetGroupWithActivityAtDateResponse(this.group, this.members);

  factory GetGroupWithActivityAtDateResponse.fromJson(Map<String, dynamic> json){
    return GetGroupWithActivityAtDateResponse(
      BasicGroup.fromJson(json['group']),
      (json['members'] as List).map((item) => Member.fromJson(item)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'group': group.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
      // Add other properties here...
    };
  }

}