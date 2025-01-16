class UserModel {
  String? uId;
  String? name;
  String? email;
  String? profilePicUrl;
  String? bio;
  UserModel({this.uId, this.email, this.name, this.profilePicUrl, this.bio});
  UserModel.formJson(Map<String, dynamic> json) {
    uId = json["uId"];
    name = json["name"];
    email = json["email"];
    profilePicUrl = json["profilePicUrl"];
    bio = json["bio"];
  }
  Map<String, dynamic> toJson() {
    return {
      "uId": uId,
      "name": name,
      "email": email,
      "profilePicUrl": profilePicUrl,
      "bio": bio
    };
  }
}
