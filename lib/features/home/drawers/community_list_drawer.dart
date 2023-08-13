import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ComunityList extends ConsumerWidget {
  const ComunityList({super.key});

  void navigateToCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            )
          ],
        ),
      )),
    );
  }
}
