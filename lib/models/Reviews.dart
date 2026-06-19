class Reviews {
  final int? id, itmid, date;
  final String? email;
  String? content;
  String? rating;

  Reviews({
    this.id,
    this.email,
    this.content,
    this.date,
    this.itmid,
    this.rating,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    print(json['photo']);
    int id = int.parse(json['id'].toString());
    int itmid = int.parse(json['itmid'].toString());
    int dateadded = int.parse(json['dateadded'].toString());
    return Reviews(
      id: id,
      email: json['email'] as String?,
      content: json['content'] as String?,
      date: dateadded,
      itmid: itmid,
      rating: json['rating'].toString(),
    );
  }
}
