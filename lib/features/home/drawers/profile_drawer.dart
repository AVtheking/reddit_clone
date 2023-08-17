import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/themes/palette.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void logout(WidgetRef ref) {
    ref.read(controllerProvider.notifier).logout();
  }

  void navigateToProfileScreen(String uid, BuildContext context) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'u/${user.name} Contacts',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("My Profile"),
            onTap: () {
              navigateToProfileScreen(user.uuid, context);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text("Log out"),
            onTap: () {
              logout(ref);
            },
          ),
          Switch.adaptive(
              value: ref.watch(themeProvider.notifier).mode == ThemeMode.dark,
              onChanged: (val) {
                toggleTheme(ref);
              })
        ],
      )),
    );
  }
}
