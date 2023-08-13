import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/communities/repository/community_repo.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityController {
  final CommunityRepository _communityRepositry;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepositry = communityRepository,
        _ref = ref;

  void createCommunity(String name, BuildContext context) async {
    final uid = _ref.read(userProvider);
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid.toString()],
      modes: [uid.toString()],
    );
    final res = await _communityRepositry.createCommunity(community);
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
}
