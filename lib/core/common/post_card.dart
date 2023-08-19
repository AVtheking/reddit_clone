import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/themes/palette.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTypeImage = post.type == 'image';
    bool isTypetext = post.type == 'text';
    bool isTypeLink = post.type == 'link';
    void deletePost(BuildContext context, Post post) async {
      ref.watch(postControllerProvider.notifier).deletePost(post, context);
    }

    void navigateToCommentsScreen(Post post) {
      Routemaster.of(context).push('/post/${post.id}/comments');
    }

    void upvote(Post post) async {
      ref.watch(postControllerProvider.notifier).upvote(post);
    }

    void downvote(Post post) async {
      ref.watch(postControllerProvider.notifier).downvote(post);
    }

    void navigateToCommunityScreen() async {
      Routemaster.of(context).push('/r/${post.communityName}');
    }

    final user = ref.watch(userProvider)!;

    void navigateToUserProfile() async {
      Routemaster.of(context).push('/user-profile/${user.uuid}');
    }

    final currentTheme = ref.watch(themeProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: navigateToCommunityScreen,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(post.communityProfilePic),
                          radius: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: navigateToUserProfile,
                              child: Text(
                                "r/${post.communityName}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "u/${post.username}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ref
                      .watch(getCommunityByNameProvider(post.communityName))
                      .when(
                        data: (data) {
                          if (data.modes.contains(user.uuid)) {
                            return IconButton(
                              onPressed: () {
                                deletePost(context, post);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Palette.redColor,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (isTypeImage)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  post.link!,
                  fit: BoxFit.cover,
                ),
              ),
            if (isTypeLink)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: AnyLinkPreview(
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  link: post.link!,
                ),
              ),
            if (isTypetext)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    post.description!,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        upvote(post);
                      },
                      icon: const Icon(Constants.up),
                      color: post.upvotes.contains(user.uuid)
                          ? Palette.redColor
                          : Palette.whiteColor,
                    ),
                    Text(
                      "${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length} ",
                    ),
                    IconButton(
                      onPressed: () {
                        downvote(post);
                      },
                      icon: const Icon(Constants.down),
                      color: post.downvotes.contains(user.uuid)
                          ? Palette.blueColor
                          : Palette.whiteColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        navigateToCommentsScreen(post);
                      },
                      icon: const Icon(Icons.comment),
                    ),
                    Text(
                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}'),
                  ],
                ),
                ref.watch(getCommunityByNameProvider(post.communityName)).when(
                      data: (data) {
                        if (data.modes.contains(user.uuid)) {
                          return IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.admin_panel_settings),
                          );
                        }
                        return const SizedBox();
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
              ],
            ),
          ]),
    );
  }
}
