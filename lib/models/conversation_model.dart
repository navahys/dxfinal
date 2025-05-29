import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String? conversationId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? plantId;
  final String? summary;
  final String? lastMessageId;
  final int messageCount;

  ConversationModel({
    this.conversationId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.plantId,
    this.summary,
    this.lastMessageId,
    this.messageCount = 0,
  });

  // Firestore에서 데이터 가져올 때 사용
  factory ConversationModel.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return ConversationModel(
      conversationId: id,
      userId: data['user_id'] ?? '',
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : DateTime.now(),
      plantId: data['plant_id'],
      summary: data['summary'],
      lastMessageId: data['last_message_id'],
      messageCount: data['message_count'] ?? 0,
    );
  }

  // Firestore에 저장할 때 사용
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'plant_id': plantId,
      'summary': summary,
      'last_message_id': lastMessageId,
      'message_count': messageCount,
    };
  }

  // 새 대화 생성
  factory ConversationModel.create({
    required String userId,
    String? plantId,
  }) {
    final now = DateTime.now();
    return ConversationModel(
      userId: userId,
      createdAt: now,
      updatedAt: now,
      plantId: plantId,
      messageCount: 0,
    );
  }

  // 복사본 생성
  ConversationModel copyWith({
    String? conversationId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? plantId,
    String? summary,
    String? lastMessageId,
    int? messageCount,
  }) {
    return ConversationModel(
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plantId: plantId ?? this.plantId,
      summary: summary ?? this.summary,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  // 시간 포맷팅
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  String toString() {
    return 'ConversationModel(id: $conversationId, userId: $userId, messageCount: $messageCount)';
  }
}