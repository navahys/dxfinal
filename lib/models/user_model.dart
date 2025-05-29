import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email; // Firebase Auth에서 가져온 값
  final String userName;
  final DateTime createdAt;
  final String preferredVoice;
  final bool notificationYn;
  final String? gender;
  final String language;
  final List<String> preferredActivities;
  final String? profileImageUrl;
  final bool useWhisperApiYn;
  final String themeMode;
  final bool autoSaveConversationsYn;
  final String? ageGroup;

  UserModel({
    required this.uid,
    required this.email,
    required this.userName,
    required this.createdAt,
    required this.preferredVoice,
    required this.notificationYn,
    this.gender,
    required this.language,
    required this.preferredActivities,
    this.profileImageUrl,
    required this.useWhisperApiYn,
    required this.themeMode,
    required this.autoSaveConversationsYn,
    required this.ageGroup,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid, String email) {
    return UserModel(
      uid: uid,
      email: email, // Firebase Auth에서 전달받음
      userName: data['user_name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      preferredVoice: data['preferred_voice'] ?? 'default',
      notificationYn: data['notification_yn'] ?? true,
      gender: data['gender'],
      language: data['language'] ?? 'ko',
      preferredActivities: List<String>.from(data['preferred_activities'] ?? []),
      profileImageUrl: data['profile_image_url'],
      useWhisperApiYn: data['use_whisper_api_yn'] ?? false,
      themeMode: data['theme_mode'] ?? 'light',
      autoSaveConversationsYn: data['auto_save_conversations_yn'] ?? true,
      ageGroup: data['age_group'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // email은 Firebase Auth에서 관리하므로 Firestore에 저장하지 않음
      'user_name': userName,
      'createdAt': Timestamp.fromDate(createdAt),
      'preferred_voice': preferredVoice,
      'notification_yn': notificationYn,
      'gender': gender,
      'language': language,
      'preferred_activities': preferredActivities,
      'profile_image_url': profileImageUrl,
      'use_whisper_api_yn': useWhisperApiYn,
      'theme_mode': themeMode,
      'auto_save_conversations_yn': autoSaveConversationsYn,
      'age_group': ageGroup,
    };
  }
}