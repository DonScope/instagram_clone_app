  String generateChatId(String userId1, String userId2) {
  // بنقارن بين الuserIds بشكل أبجدي عشان نحط الأصغر أولاً
  return userId1.compareTo(userId2) < 0 
      ? '${userId1}_$userId2' 
      : '${userId2}_$userId1';
}