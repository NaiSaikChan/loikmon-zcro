class Categories {
  final int? id;
  final String? title;
  final String? type;
  final String? thumbnailUrl;
  final int? bookscount, articlescount;

  static const String TABLE = "categories";
  static final columns = [
    "id",
    "title",
    "thumbnailUrl",
    "bookscount",
    "articlescount"
  ];

  Categories({
    this.id,
    this.title,
    this.type,
    this.thumbnailUrl,
    this.bookscount,
    this.articlescount,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    //int count = int.parse(json['media_count'].toString());
    int bookscount = json['bookscount'] == null
        ? 0
        : int.parse(json['bookscount'].toString());
    int articlescount = json['articlescount'] == null
        ? 0
        : int.parse(json['articlescount'].toString());
    return Categories(
      id: id,
      title: json['name'] as String?,
      type: json['type'] as String?,
      thumbnailUrl: json['thumbnail'] as String?,
      bookscount: bookscount,
      articlescount: articlescount,
    );
  }

  factory Categories.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int bookscount = json['bookscount'] == null
        ? 0
        : int.parse(json['bookscount'].toString());
    int articlescount = json['articlescount'] == null
        ? 0
        : int.parse(json['articlescount'].toString());
    return Categories(
      id: id,
      title: json['name'] as String?,
      type: json['type'] as String?,
      thumbnailUrl: "",
      bookscount: bookscount,
      articlescount: articlescount,
    );
  }

  factory Categories.fromSubCategory(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Categories(
      id: id,
      title: json['name'] as String?,
      type: json['type'] as String?,
      thumbnailUrl: "",
    );
  }

  factory Categories.fromMap(Map<String, dynamic> data) {
    return Categories(
      id: data['id'],
      title: data['title'],
      thumbnailUrl: data['thumbnailUrl'],
      bookscount: data['bookscount'],
      articlescount: data['articlescount'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
        "bookscount": bookscount,
        "articlescount": articlescount,
      };
}
