import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
    (ref) => PostController(
        postRepository: ref.read(postRepository),
        ref: ref,
        storageRepository: ref.read(storageRepositoryProvider)));

final postProvider = StreamProvider.family(
  (ref, List<Community> communities) {
    return ref.watch(postControllerProvider.notifier).fetchPost(communities);
  },
);

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _ref = ref,
        _postRepository = postRepository,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uuid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);
    final res = await _postRepository.addPost(post);
    res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.toString()),
              ),
            ), (r) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Posted Successfully"),
      ));
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uuid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);
    final res = await _postRepository.addPost(post);
    res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.toString()),
              ),
            ), (r) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Posted Successfully"),
      ));
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFiles(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);
    imageRes.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.toString()),
              ),
            ), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uuid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r);
      final res = await _postRepository.addPost(post);
      res.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.toString()),
                ),
              ), (r) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Posted Successfully"),
        ));
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    }
    return Stream.value([]);
  }
}
