class UserModel {
  String? id;
  String? name;
  String? email;
  UserModel({
    this.id,
    this.email,
    this.name,
  });
  UserModel.formJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
