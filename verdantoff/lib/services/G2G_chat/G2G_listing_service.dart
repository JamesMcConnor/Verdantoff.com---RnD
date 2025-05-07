import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/G2G_chat/group_model.dart';

class G2GListingService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');

  /// Retrieves a list of groups the user has joined, along with unread message counts
  Future<List<Map<String, dynamic>>> getMyGroupsWithUnreadCounts(
      String userId) async {
    QuerySnapshot snapshot = await groupsCollection
        .where('roles.$userId', isNotEqualTo: null)
        .get();

    List<Map<String, dynamic>> myGroups = [];

    for (var doc in snapshot.docs) {
      var memberSnapshot = await groupsCollection
          .doc(doc.id)
          .collection('members')
          .doc(userId)
          .get();

      if (memberSnapshot.exists) {
        myGroups.add({
          'group': GroupModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>),
          'unreadCount': memberSnapshot['unreadCount'] ?? 0,
        });
      }
    }

    return myGroups;
  }
}
