import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/features/post/widget/comment_card.dart';
import 'package:reddit_clone/models/post.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComent(Post post) async {
    ref.read(postControllerProvider.notifier).addComents(
          text: commentController.text.trim(),
          post: post,
          context: context,
        );
    commentController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Column(
                children: [
                  PostCard(post: post),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: "What are your thoughts?",
                              filled: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addComent(post);
                        },
                        icon: const Icon(Icons.send_sharp),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ref.watch(commentsProvider(post.id)).when(
                        data: (data) => Expanded(
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              }),
                        ),
                        error: (error, stackTrace) => ErrorText(
                          text: error.toString(),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              text: error.toString(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
