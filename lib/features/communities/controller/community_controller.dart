import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/communities/repository/community_repo.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunity();
});
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  ),
);
final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepositry;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepositry = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uuid;
    // print(uid);
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      modes: [uid],
    );
    final res = await _communityRepositry.createCommunity(community);
    state = false;
    res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.message),
              ),
            ), (r) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Community Created Succesfully"),
        ),
      );
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uuid;

    return _communityRepositry.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepositry.getCommunityByName(name);
  }

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required Community community}) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.message),
          ),
        ),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.message),
          ),
        ),
        (r) => community = community.copyWith(banner: r),
      );
    }
    final res = await _communityRepositry.editCommunity(community);
    state = false;
    res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.message),
              ),
            ),
        (r) => Routemaster.of(context).pop());
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if (community.members.contains(user.uuid)) {
      res = await _communityRepositry.leaveCommunity(community, user.uuid);
    } else {
      res = await _communityRepositry.joinCommunity(community, user.uuid);
    }
    res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.message),
              ),
            ), (r) {
      if (community.members.contains(user.uuid)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Community left Successfully"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Community joined Successfully"),
          ),
        );
      }
    });
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepositry.searchCommunity(query);
  }
}
