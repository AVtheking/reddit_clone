import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';

final communityRepositoryProvider = Provider(
    (ref) => CommunityRepository(firestore: ref.read(firestoreProvider)));

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
//This is the repository class to create store and update community
  FutureVoid createCommunity(Community community) async {
    try {
      //first check if already a community exist with specific name
      var communitiesDoc = await _communities.doc(community.name).get();
      if (communitiesDoc.exists) {
        throw "Community with same name already exists";
      } // if not then store it in firebase
      return right(
        _communities.doc(community.name).set(
              community.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// this is a function which checks if there is a community in which our user is in it
//returns thie list of community
  Stream<List<Community>> getUserCommunity(String uid) {
    return _communities //we store user id in the community not user name because userid is unique
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> community = [];
      for (var docs in event.docs) {
        community.add(Community.fromMap(docs.data() as Map<String, dynamic>));
      }
      return community;
    });
  }

//Function to get community by searching its name
  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  // FutureVoid editCommunity(Community community) async {
  //   try {
  //     return right(_communities.doc(community.name).update(community.toMap()));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  //function to edit community banner or avatar
  //in this we take editted community from the controller and update the previous one
  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        _communities.doc(community.name).update(
              community.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity(Community community, String uid) async {
    try {
      return right(_communities.doc(community.name).update({
        'members': FieldValue.arrayUnion([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(Community community, String uid) async {
    try {
      return right(_communities.doc(community.name).update({
        'members': FieldValue.arrayRemove([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

//Function to add moderater in the community just simple
  FutureVoid addModerater(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({'modes': uids}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  Stream<List<Post>> getCommunityPost(String communityName) {
    return _post
        .where('communityName', isEqualTo: communityName)
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
