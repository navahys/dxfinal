import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 사용자 ID 가져오기
  String? get currentUserId => _auth.currentUser?.uid;

  // 대화 저장 (사용자별로)
  Future<String> saveConversation({
    required String title,
    required String lastMessage,
    required List<Map<String, dynamic>> messages,
  }) async {
    final conversationData = {
      'userId': currentUserId,
      'title': title,
      'lastMessage': lastMessage,
      'timestamp': FieldValue.serverTimestamp(),
      'messages': messages,
    };

    DocumentReference doc = await _firestore
        .collection('plant_conversations')
        .add(conversationData);
    return doc.id;
  }

  // 현재 사용자의 대화 목록 가져오기
  Stream<QuerySnapshot> getConversations() {
    if (currentUserId == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('plant_conversations')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 메시지 추가
  Future<void> addMessageToConversation(
      String conversationId,
      Map<String, dynamic> message
      ) async {
    await _firestore
        .collection('plant_conversations')
        .doc(conversationId)
        .update({
      'messages': FieldValue.arrayUnion([message]),
      'lastMessage': message['text'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}