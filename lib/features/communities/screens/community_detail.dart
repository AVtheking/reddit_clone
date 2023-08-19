import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDetailScreen extends ConsumerWidget {
  final String name;
  const CommunityDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    void navigateToModScreen() {
      Routemaster.of(context).push("/mod-tools/$name");
    }

    return Scaffold(
        body: ref.watch(getCommunityByNameProvider(name)).when(
              data: (data) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      expandedHeight: 150,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              data.banner,
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data.avatar),
                                radius: 35,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${data.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                                data.modes.contains(user.uuid)
                                    ? OutlinedButton(
                                        onPressed: navigateToModScreen,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25)),
                                        child: const Text("Mod Tools"),
                                      )
                                    : OutlinedButton(
                                        onPressed: () {
                                          ref
                                              .watch(communityControllerProvider
                                                  .notifier)
                                              .joinCommunity(data, context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25)),
                                        child: Text(
                                            data.members.contains(user.uuid)
                                                ? 'Joined'
                                                : 'Join'),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text("${data.members.length} members")
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: ref.watch(communtiyPostProvider(name)).when(
                    data: (data) => ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (ctx, index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        ),
                    error: (error, stackTrace) =>
                        ErrorText(text: error.toString()),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ),
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
