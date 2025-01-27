class UserModel {
  String? uId;
  String? name;
    String? userName;
    String? phoneNumber;
  String? email;
  String? profilePicUrl;
  String? bio;
  UserModel({this.uId, this.email, this.name, this.profilePicUrl, this.bio, this.userName, this.phoneNumber});
  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json["uId"];
    name = json["name"];
    email = json["email"];
    userName = json["userName"];
    phoneNumber = json["phoneNumber"];
    profilePicUrl = json["profilePictureUrl"];
    bio = json["bio"];
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "uId" : uId,
      "email": email,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "bio": bio
    };
  }
  Map<String, dynamic> toJsonForUpdate() {
    return {
      "name": name,
      "email": email,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "bio": bio
    };
  }
}
