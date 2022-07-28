class UserModel{
  User user;
  String satker;

  UserModel({
    this.user,
    this.satker
  });

  factory UserModel.fromJson(Map<String, dynamic> parsedJson){
    return UserModel(
        user: User.fromJson(parsedJson['user']),
        satker : parsedJson ['satker']
    );
  }
}

class User{
  int id;
  String name;
  String gravatar;
  String email;
  String username;
  String email_token;
  int jabatan;

  User({
    this.id,
    this.name,
    this.gravatar,
    this.email,
    this.username,
    this.email_token,
    this.jabatan
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      gravatar: json['gravatar'],
      email: json['email'],
      username: json['username'],
      email_token: json['email_token'],
      jabatan: json['jabatan']
    );
  }
}

class Satkers{
  int id;
  String name;

  Satkers({
    this.id,
    this.name
  });

  factory Satkers.fromJson(Map<String, dynamic> json){
    return Satkers(
      id: json['id'],
      name: json['name']
    );
  }
}