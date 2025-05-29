/// widgets/display_name_avatar.dart
///
/// A small reusable widget that shows a user’s avatar and display-name
/// by looking up the user document in `users/{uid}`.  If the user has
/// no avatar, the widget falls back to showing the user’s initials
/// or the full display-name.
///
/// Usage:
/// ```dart
/// DisplayNameAvatar(
///   uid: otherUid,
///   radius: 36,              // optional, default = 24
///   textStyle: TextStyle(    // optional
///     color: Colors.white70,
///     fontSize: 16,
///   ),
/// )
/// ```
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayNameAvatar extends StatelessWidget {
  const DisplayNameAvatar({
    super.key,
    required this.uid,
    this.radius = 24,
    this.textStyle,
  });

  final String uid;
  final double radius;
  final TextStyle? textStyle;

  Future<_UserProfile?> _fetchProfile() async {
    final snap =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!snap.exists) return null;
    final data = snap.data()!;
    return _UserProfile(
      name: (data['userName'] as String?)?.trim() ?? 'Unknown',
      avatarUrl: data['avatar'] as String?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_UserProfile?>(
      future: _fetchProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Skeleton
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(Icons.person, color: Colors.white30),
          );
        }

        final profile = snapshot.data!;
        final hasAvatar = profile.avatarUrl?.isNotEmpty ?? false;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey.shade800,
              backgroundImage:
              hasAvatar ? NetworkImage(profile.avatarUrl!) : null,
              child: hasAvatar
                  ? null
                  : Text(
                _initials(profile.name),
                style: TextStyle(
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// helpers
class _UserProfile {
  _UserProfile({required this.name, this.avatarUrl});
  final String name;
  final String? avatarUrl;
}

String _initials(String name) {
  final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();
  return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
}
