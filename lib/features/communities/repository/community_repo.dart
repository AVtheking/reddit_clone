import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/community.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      //checking if community already exists
      var communityDocs = await _communites.doc(community.name).get();
      if (communityDocs.exists) {
        throw 'Community with same name already exists';
      }

      //if not then return the community detail
      return right(_communites.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communites =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
