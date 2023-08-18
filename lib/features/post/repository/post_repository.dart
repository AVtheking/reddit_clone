import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';

final postRepository =
    Provider((ref) => PostRepository(firestore: ref.read(firestoreProvider)));

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);
//This is a repository class which just stored the recieved post from the controller class in firebaase
  FutureVoid addPost(Post post) async {
    try {
      return right(_post
          .doc(post.id)
          .set(post.toMap())); //set is use to store in firebase
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

//it matches the community which have same name as that of post and orders them
// to return the list  of post
  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    return _post
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
