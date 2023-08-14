import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

class ComunityList extends ConsumerWidget {
  const ComunityList({super.key});

  void navigateToCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCommunities = ref.watch(userCommunityProvider);

    return Drawer(
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ListTile(
                title: const Text("Create a community"),
                leading: const Icon(Icons.add),
                onTap: () => navigateToCommunityScreen(context),
              ),
              userCommunities.when(
                data: (data) {
                  // Debug print fetched communities
                  // print("Fetched communities: $data");

                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, index) {
                        final community = data[index];
                        return ListTile(
                          title: Text(community.name),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          onTap: () {
                            navigateToCommunity(context, community);
                          },
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  // Debug print error message
                  // print("Error fetching communities: $error");

                  return ErrorText(text: error.toString());
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
