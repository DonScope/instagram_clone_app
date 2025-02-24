class UserModel {
  String? uId;
  String? name;
  String? userName;
  String? phoneNumber;
  String? email;
  int? followersCount;
  int? followingCount;
  String? profilePicUrl;
  String? bio;
  String? fcmToken;

  UserModel({
    this.fcmToken,
    this.uId,
    this.email,
    this.name,
    this.profilePicUrl,
    this.bio = "",
    this.userName = "",
    this.phoneNumber = "",
    this.followersCount = 0,
    this.followingCount = 0,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fcmToken = json["fcmToken"];
    uId = json["uId"];
    name = json["name"];
    email = json["email"];
    userName = json["userName"];
    phoneNumber = json["phoneNumber"];
    profilePicUrl = json["profilePicUrl"];
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
    bio = json["bio"];
  }

  Map<String, dynamic> toJson() {
    return {
      "uId": uId,
      "name": name,
      "email": email,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "profilePicUrl": profilePicUrl,
      "followersCount": followersCount,
      "followingCount": followingCount,
      "fcmToken" : fcmToken,
      "bio": bio,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      "name": name,
      "email": email,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "bio": bio,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uId == uId;
  }

  @override
  int get hashCode => uId?.hashCode ?? 0;
}
