import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/themes/palette.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToTypeScreen(String type) {
      Routemaster.of(context).push('/add-post/$type');
    }

    final currentTheme = ref.watch(themeProvider);
    double cardHeightWidth = 120;
    double iconSize = 60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            navigateToTypeScreen('image');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToTypeScreen('text');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToTypeScreen('link');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
