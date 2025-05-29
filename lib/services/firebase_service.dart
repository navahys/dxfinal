import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiiun/models/user_model.dart';
import 'package:tiiun/models/conversation_model.dart';
import 'package:tiiun/models/message_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== 🔐 사용자 정보 관련 ==========

  String? get currentUserId => _auth.currentUser?.uid;
  User? get currentUser => _auth.currentUser;
  String? get currentUserEmail => _auth.currentUser?.email;

  // ========== 🔑 인증 관련 메서드 ==========

  // 회원가입
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String userName = '',
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      final userData = {
        'user_name': userName,
        'createdAt': FieldValue.serverTimestamp(),
        'preferred_voice': 'default',
        'notification_yn': true,
        'gender': null,
        'language': 'ko',
        'preferred_activities': [],
        'profile_image_url': null,
        'use_whisper_api_yn': false,
        'theme_mode': 'light',
        'auto_save_conversations_yn': true,
        'age_group': null,
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      return UserModel(
        uid: user.uid,
        email: user.email!,
        userName: userName,
        createdAt: DateTime.now(),
        preferredVoice: 'default',
        notificationYn: true,
        gender: null,
        language: 'ko',
        preferredActivities: [],
        profileImageUrl: null,
        useWhisperApiYn: false,
        themeMode: 'light',
        autoSaveConversationsYn: true,
        ageGroup: null,
      );
    } catch (e) {
      print('회원가입 오류: $e');
      return null;
    }
  }

  // 로그인
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      return await getUserData(user.uid);
    } catch (e) {
      print('로그인 오류: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ========== 👤 사용자 정보 관리 ==========

  // 사용자 데이터 가져오기
  Future<UserModel?> getUserData(String uid) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(
          doc.data()!,
          uid,
          user.email!,
        );
      }
      return null;
    } catch (e) {
      print('사용자 데이터 가져오기 오류: $e');
      return null;
    }
  }

  // 현재 사용자 데이터 스트림
  Stream<UserModel?> getCurrentUserStream() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await getUserData(user.uid);
    });
  }

  // 사용자 정보 업데이트
  Future<bool> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toFirestore());
      return true;
    } catch (e) {
      print('사용자 정보 업데이트 오류: $e');
      return false;
    }
  }

  // ========== 💬 대화 관리 (새로운 구조) ==========

  // 새 대화 생성
  Future<ConversationModel?> createConversation({
    String? plantId,
  }) async {
    try {
      if (currentUserId == null) return null;

      final conversation = ConversationModel.create(
        userId: currentUserId!,
        plantId: plantId,
      );

      final docRef = await _firestore
          .collection('conversations')
          .add(conversation.toFirestore());

      return conversation.copyWith(conversationId: docRef.id);
    } catch (e) {
      print('대화 생성 오류: $e');
      return null;
    }
  }

  // 메시지 추가
  Future<MessageModel?> addMessage({
    required String conversationId,
    required String content,
    required String sender,
    String type = 'text',
  }) async {
    try {
      final message = MessageModel.create(
        conversationId: conversationId,
        content: content,
        sender: sender,
        type: type,
      );

      // 1. 메시지 저장
      final docRef = await _firestore
          .collection('messages')
          .add(message.toFirestore());

      // 2. 대화 정보 업데이트 (last_message_id, message_count, updated_at)
      await _firestore.collection('conversations').doc(conversationId).update({
        'last_message_id': docRef.id,
        'message_count': FieldValue.increment(1),
        'updated_at': FieldValue.serverTimestamp(),
      });

      return message.copyWith(messageId: docRef.id);
    } catch (e) {
      print('메시지 추가 오류: $e');
      return null;
    }
  }

  // 대화 목록 가져오기 (모델로 반환)
  Stream<List<ConversationModel>> getConversations() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('conversations')
        .where('user_id', isEqualTo: currentUserId)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConversationModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // 메시지 목록 가져오기 (모델로 반환)
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _firestore
        .collection('messages')
        .where('conversation_id', isEqualTo: conversationId)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // 특정 메시지 가져오기 (last_message_id로 사용)
  Future<MessageModel?> getMessage(String messageId) async {
    try {
      final doc = await _firestore.collection('messages').doc(messageId).get();
      if (doc.exists) {
        return MessageModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      return null;
    }
  }

  // 대화 삭제
  Future<bool> deleteConversation(String conversationId) async {
    try {
      // 1. 해당 대화의 모든 메시지 삭제
      final messagesQuery = await _firestore
          .collection('messages')
          .where('conversation_id', isEqualTo: conversationId)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in messagesQuery.docs) {
        batch.delete(doc.reference);
      }

      // 2. 대화 삭제
      batch.delete(_firestore.collection('conversations').doc(conversationId));

      await batch.commit();
      return true;
    } catch (e) {
      print('대화 삭제 오류: $e');
      return false;
    }
  }

  // ========== 🎯 퀵액션 전용 메서드 ==========

  // 퀵액션별 메시지 매핑
  Map<String, String> get quickActionMessages => {
    '자랑거리': '나 자랑할 거 있어!',
    '고민거리': '요즘 고민이 있어서 이야기하고 싶어',
    '위로가 필요할 때': '나 좀 위로해줘',
    '시시콜콜': '심심해! 나랑 이야기하자!',
    '끝말 잇기': '끝말 잇기 하자!',
    '화가 나요': '나 너무 화나는 일 있어',
  };

  // 퀵액션으로 대화 시작 (간단하게)
  Future<ConversationModel?> startQuickActionConversation(String actionText) async {
    try {
      // 1. 새 대화 생성
      final conversation = await createConversation();
      if (conversation == null) return null;

      // 2. 첫 메시지 추가 (사용자)
      final initialMessage = quickActionMessages[actionText] ?? '안녕하세요!';
      await addMessage(
        conversationId: conversation.conversationId!,
        content: initialMessage,
        sender: 'user',
      );

      return conversation;
    } catch (e) {
      print('퀵액션 대화 시작 오류: $e');
      return null;
    }
  }
}