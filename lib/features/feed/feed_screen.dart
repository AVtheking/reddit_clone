import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
          data: (communities) => ref.watch(postProvider(communities)).when(
                data: (data) {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: ((context, index) {
                        final post = data[index];
                        return PostCard(
                          post: post,
                        );
                      }));
                },
                error: (error, stackTrace) => ErrorText(
                  text: error.toString(),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          error: (error, stackTrace) => ErrorText(
            text: error.toString(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
