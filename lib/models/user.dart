class User {
  String? id;
  String? name;
  String? contact;
  String? address;
  String? email;
  String? password;

  User(
      {this.id,
      this.name,
      this.contact,
      this.address,
      this.email,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    address = json['address'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['contact'] = contact;
    data['address'] = address;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
