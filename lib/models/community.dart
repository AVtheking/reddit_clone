// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<dynamic> members;
  final List<dynamic> modes;
  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.modes,
  });

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<dynamic>? members,
    List<dynamic>? modes,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      modes: modes ?? this.modes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'modes': modes,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
        id: map['id'] as String,
        name: map['name'] as String,
        banner: map['banner'] as String,
        avatar: map['avatar'] as String,
        members: List<dynamic>.from((map['members'] as List<dynamic>)),
        modes: List<dynamic>.from(
          (map['modes'] as List<dynamic>),
        ));
  }

  // @override
  // String toString() {
  //   return 'Community(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, modes: $modes)';
  // }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.modes, modes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        modes.hashCode;
  }
}
