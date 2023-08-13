import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utl.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final controllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
final authStateChangeProvider = StreamProvider(
  (ref) {
    final authController = ref.watch(controllerProvider.notifier);
    return authController.authStateChange;
  },
);
final userDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(controllerProvider.notifier).getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
