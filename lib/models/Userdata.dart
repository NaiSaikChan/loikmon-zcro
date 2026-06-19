class Userdata {
  String? email = "", name = "";
  String? firstname = "";
  String? lastname = "";
  int? seller;
  int? coins = 0;

  static const String TABLE = "userdata";
  static final columns = [
    "email",
    "name",
    "seller",
    "coins",
  ];

  Userdata({
    this.seller,
    this.email,
    this.name,
    this.firstname,
    this.lastname,
    this.coins,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    //print(json);
    return Userdata(
      seller: int.parse(json['seller'].toString()),
      coins: int.parse(json['coins'].toString()),
      email: json['email'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      name: (json['firstname'] as String?).toString() +
          " " +
          (json['lastname'] as String?).toString(),
    );
  }

  factory Userdata.fromFCMJson(Map<String, dynamic> json) {
    return Userdata(
      seller: int.parse(json['seller'].toString()),
      coins: int.parse(json['coins'].toString()),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      name: (json['firstname'] as String?).toString() +
          " " +
          (json['lastname'] as String?).toString(),
      email: json['email'] as String?,
    );
  }

  factory Userdata.fromJson2(Map<String, dynamic> json) {
    return Userdata(
      seller: int.parse(json['seller'].toString()),
      coins: int.parse(json['coins'].toString()),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      name: (json['firstname'] as String?).toString() +
          " " +
          (json['lastname'] as String?).toString(),
      email: json['email'] as String?,
    );
  }

  factory Userdata.fromMap(Map<String, dynamic> data) {
    return Userdata(
      firstname: "",
      lastname: "",
      seller: data['seller'],
      coins: data['coins'],
      name: data['name'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toMap() => {
        "seller": seller,
        "coins": coins,
        "name": name,
        "email": email,
      };
}
