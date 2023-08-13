// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String banner;
  final String profilePic;
  final String uuid;
  final bool isAuthenticated;
  final int karma;
  final List<dynamic> awards;
  UserModel({
    required this.name,
    required this.banner,
    required this.profilePic,
    required this.uuid,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? banner,
    String? profilePic,
    String? uuid,
    bool? isAuthenticated,
    int? karma,
    List<dynamic>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      banner: banner ?? this.banner,
      profilePic: profilePic ?? this.profilePic,
      uuid: uuid ?? this.uuid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'banner': banner,
      'profilePic': profilePic,
      'uuid': uuid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        banner: map['banner'] as String,
        profilePic: map['profilePic'] as String,
        uuid: map['uuid'] as String,
        isAuthenticated: map['isAuthenticated'] as bool,
        karma: map['karma'] as int,
        awards: List<dynamic>.from(
          (map['awards'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserMode(name: $name, banner: $banner, profilePic: $profilePic, uuid: $uuid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.banner == banner &&
        other.profilePic == profilePic &&
        other.uuid == uuid &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        banner.hashCode ^
        profilePic.hashCode ^
        uuid.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}
