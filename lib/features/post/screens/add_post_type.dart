import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/utils.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  File? bannerFile;
  void selectBannerFile() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == 'link' &&
        linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter all valid Field"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTypeImage = widget.type == 'image';
    bool isTypetext = widget.type == 'text';
    bool isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(onPressed: sharePost, child: const Text("Share")),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        filled: true,
                        hintText: "Enter title here",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18)),
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerFile,
                      child: DottedBorder(
                        color: Colors.white,
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        dashPattern: const [10, 4],
                        radius: const Radius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                        ),
                      ),
                    ),
                  if (isTypetext)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: "Enter title here",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18)),
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: "Enter title here",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18)),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Select Community"),
                  ),
                  ref.watch(userCommunityProvider).when(
                        data: (data) {
                          // communities = data;
                          if (data.isEmpty) {
                            return const SizedBox();
                          }

                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value == null) {
                                  return;
                                }
                                selectedCommunity = value;
                                // print(community!.name);
                              });
                            },
                          );
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
    );
  }
}
