import 'package:flutter/material.dart';
import '../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../services/models/G2G_chat/group_model.dart';

class GroupSearchViewModel extends ChangeNotifier {
  final G2GMembersService _membersService = G2GMembersService();

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<GroupModel> searchResults = [];

  Future<void> searchGroups() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    searchResults.clear();

    // Try exact search by groupCode first
    final exactResult = await _membersService.searchGroupByCode(query);
    if (exactResult != null) {
      searchResults.add(GroupModel.fromFirestore(
        exactResult.id,
        exactResult.data() as Map<String, dynamic>,
      ));
    } else {
      // If exact search fails, perform fuzzy search by group name
      final fuzzySnapshot = await _membersService.groupsCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      searchResults = fuzzySnapshot.docs
          .map((doc) => GroupModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      ))
          .toList();
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
