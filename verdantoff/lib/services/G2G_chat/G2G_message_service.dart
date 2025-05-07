import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/G2G_chat/group_last_message_model.dart';
import '../models/G2G_chat/group_message_model.dart';

class G2GMessageService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');


  /// Sends a text message to the group and updates the `lastMessage` field.
  Future<void> sendTextMessage(String groupId, GroupMessageModel message) async {
    final groupRef = groupsCollection.doc(groupId);

    // 1. Save message in subcollection
    await groupRef.collection('messages').doc(message.messageId).set(message.toFirestore());

    // 2. Fetch sender's nickname for display
    final senderDoc = await groupRef.collection('members').doc(message.senderId).get();
    final senderNickname = senderDoc.data()?['nickname'] ?? 'Unknown';

    // 3. Construct and set GroupLastMessageModel
    final lastMsg = GroupLastMessageModel(
      messageId: message.messageId,
      content: message.content,
      senderId: message.senderId,
      senderName: senderNickname,
      isEdited: false,
      isRecalled: false,
      updatedAt: DateTime.now(),
    );

    await groupRef.update({
      'lastMessage': lastMsg.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': message.senderId,
    });
  }



  /// Edits an existing group message and updates lastMessage if applicable.
  Future<void> editMessage(String groupId, String messageId, String newContent) async {
    final groupRef = groupsCollection.doc(groupId);
    final messageRef = groupRef.collection('messages').doc(messageId);

    final messageSnapshot = await messageRef.get();
    final message = GroupMessageModel.fromFirestore(
      messageSnapshot.id,
      messageSnapshot.data() as Map<String, dynamic>,
    );

    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('Edit time window has expired.');
    }

    // Update the message
    await messageRef.update({
      'content': newContent,
      'isEdited': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Check and update lastMessage if applicable
    final groupSnapshot = await groupRef.get();
    final groupData = groupSnapshot.data() as Map<String, dynamic>?;

    final rawLastMessage = groupData?['lastMessage'] as Map<String, dynamic>?;
    if (rawLastMessage != null) {
      final lastMsg = GroupLastMessageModel.fromMap(rawLastMessage);
      if (lastMsg.messageId == messageId) {
        await groupRef.update({
          'lastMessage.content': newContent,
          'lastMessage.isEdited': true,
          'lastMessage.updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }


  /// Recalls a group message and updates lastMessage if applicable.
  Future<void> recallMessage(String groupId, String messageId) async {
    final groupRef = groupsCollection.doc(groupId);
    final messageRef = groupRef.collection('messages').doc(messageId);

    final messageSnapshot = await messageRef.get();
    final message = GroupMessageModel.fromFirestore(
      messageSnapshot.id,
      messageSnapshot.data() as Map<String, dynamic>,
    );

    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('Recall time window has expired.');
    }

    // Only update isRecalled
    await messageRef.update({
      'isRecalled': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Check and update lastMessage if applicable
    final groupSnapshot = await groupRef.get();
    final groupData = groupSnapshot.data() as Map<String, dynamic>?;

    final rawLastMessage = groupData?['lastMessage'] as Map<String, dynamic>?;
    if (rawLastMessage != null) {
      final lastMsg = GroupLastMessageModel.fromMap(rawLastMessage);
      if (lastMsg.messageId == messageId) {
        await groupRef.update({
          'lastMessage.isRecalled': true,
          'lastMessage.updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }




  /// Marks a message as read by adding the user's ID to the 'readBy' list
  Future<void> markMessageAsRead(
      String groupId, String messageId, String userId) async {
    await groupsCollection
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .update({
      'readBy': FieldValue.arrayUnion([userId]),
    });
  }

  /// Placeholder for sending an image message
  Future<void> sendImageMessage() async {
    // TODO: Implement sendImageMessage
  }

  /// Placeholder for sending a link message
  Future<void> sendLinkMessage() async {
    // TODO: Implement sendLinkMessage
  }

  /// Placeholder for sending a voice message
  Future<void> sendVoiceMessage() async {
    // TODO: Implement sendVoiceMessage
  }

  /// Placeholder for sending a strong notification (high-priority alert)
  Future<void> sendStrongNotification() async {
    // TODO: Implement sendStrongNotification
  }
}
