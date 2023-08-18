import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/themes/palette.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTypeImage = post.type == 'image';
    bool isTypetext = post.type == 'text';
    bool isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeProvider);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration:
                BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.communityProfilePic),
                        radius: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "r/${post.communityName}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Palette.redColor,
                    ),
                  )
                ],
              ),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
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
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Constants.up),
              ),
              Text(
                "${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length} ",
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Constants.down),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment),
              ),
              Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}')
            ],
          )
        ]);
  }
}
