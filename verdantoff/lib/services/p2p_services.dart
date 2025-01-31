//Provide a unified entrance for all P2P services
import 'p2p_chat/p2p_chat_service.dart';
import 'p2p_chat/p2p_message_service.dart';
import 'p2p_chat/p2p_notification_service.dart';

/// P2PServices: Unified entry point for all P2P chat-related services.
/// This class integrates `P2PChatService`, `P2PMessageService`, and `P2PNotificationService`.
/// It provides a single interface to manage chats, messages, and notifications.
class P2PServices {
  /// Service for managing chat-related operations.
  final P2PChatService chatService = P2PChatService();

  /// Service for managing message-related operations.
  final P2PMessageService messageService = P2PMessageService();

  /// Service for managing notification-related operations.
  final P2PNotificationService notificationService = P2PNotificationService();

  /// Constructor for P2PServices.
  /// Initializes instances of chat, message, and notification services.
  P2PServices();

}
