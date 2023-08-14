//logged out
//logged in
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/communities/screens/community_detail.dart';
import 'package:reddit_clone/features/communities/screens/community_screen.dart';
import 'package:reddit_clone/features/communities/screens/edit_screen.dart';
import 'package:reddit_clone/features/communities/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        )
  },
);
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/create-community': (_) => const MaterialPage(
          child: CommunityScreen(),
        ),
    '/r/:name': (route) => MaterialPage(
          child: CommunityDetailScreen(name: route.pathParameters['name']!),
        ),
    '/mod-tools/:name': (route) => MaterialPage(
          child: ModToolsScreen(name: route.pathParameters['name']!),
        ),
    '/edit-community/:name': (route) => MaterialPage(
          child: EditCommunityScreen(name: route.pathParameters['name']!),
        )
  },
);
