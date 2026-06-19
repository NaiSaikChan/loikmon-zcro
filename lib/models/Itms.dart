class Itms {
  final String? title;
  int? id;
  int? type;

  static const String TABLE = "countries";
  static final columns = [
    "id",
    "title",
  ];

  Itms(
    this.id,
    this.title,
    this.type,
  );

  factory Itms.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Itms(id, json['name'] as String?, 0);
  }

  factory Itms.fromMap(Map<String, dynamic> data) {
    return Itms(data['id'], data['title'], 0);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
