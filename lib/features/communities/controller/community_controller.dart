import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
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
      communityRepository: ref.watch(communityRepositoryProvider), ref: ref),
);

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepositry;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepositry = communityRepository,
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
}
