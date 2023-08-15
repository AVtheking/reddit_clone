import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';

class AddModeraterScreen extends ConsumerStatefulWidget {
  const AddModeraterScreen({super.key, required this.name});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddModeraterScreenState();
}

class _AddModeraterScreenState extends ConsumerState<AddModeraterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        body: ref.watch(getCommunityByNameProvider(widget.name)).when(
              data: (community) => ListView.builder(
                  itemCount: community.members.length,
                  itemBuilder: (ctx, index) {
                    final member = community.members[index];
                    return ref.watch(userDataProvider(member)).when(
                          data: (user) => CheckboxListTile(
                            value: true,
                            onChanged: (val) {},
                            title: Text(user.name),
                          ),
                          error: (error, stackTrace) => ErrorText(
                            text: error.toString(),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                  }),
              error: (error, stackTrace) => ErrorText(
                text: error.toString(),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
