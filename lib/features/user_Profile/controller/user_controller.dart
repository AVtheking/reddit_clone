import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_Profile/repository/user_repository.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>(
  (ref) => UserController(
      userRepository: ref.read(userRepositoryProvider),
      storageRepository: ref.read(storageRepositoryProvider),
      ref: ref),
);

class UserController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserController({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editUser(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required String name}) async {
    UserModel user = _ref.read(userProvider)!;
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'users/profile',
        id: user.uuid,
        file: profileFile,
      );
      res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.message),
          ),
        ),
        (r) => user = user.copyWith(profilePic: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'users/banner',
        id: user.uuid,
        file: bannerFile,
      );
      res.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.message),
                ),
              ),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);

    final res = await _userRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.message),
        ),
      ),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }
}
