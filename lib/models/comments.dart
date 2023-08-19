import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Comment {
  final String id;
  final String text;
  final String username;
  final DateTime createdAt;
  final String postId;
  final String profilePic;
  Comment({
    required this.id,
    required this.text,
    required this.username,
    required this.createdAt,
    required this.postId,
    required this.profilePic,
  });

  Comment copyWith({
    String? id,
    String? text,
    String? username,
    DateTime? createdAt,
    String? postId,
    String? profilePic,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'profilePic': profilePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      username: map['username'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, username: $username, createdAt: $createdAt, postId: $postId, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.username == username &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        username.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        profilePic.hashCode;
  }
}
