class Inbox {
  final int? id, coinsid, approved, value;
  final String? email, thumbnail;
  final String? date;
  final double? amount;

  final String? author, item, itmid, type, itmdate;

  Inbox({
    this.id,
    this.coinsid,
    this.amount,
    this.value,
    this.email,
    this.thumbnail,
    this.date,
    this.approved,
    //
    this.author,
    this.item,
    this.itmid,
    this.type,
    this.itmdate,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int coinsid = int.parse(json['coinsid'].toString());
    int approved = int.parse(json['approved'].toString());
    int value = int.parse(json['value'].toString());
    double amount = double.parse(json['amount'].toString());
    return Inbox(
      id: id,
      coinsid: coinsid,
      approved: approved,
      email: json['email'] as String?,
      thumbnail: json['thumbnail'] as String?,
      date: json['date'] as String?,
      value: value,
      amount: amount,
    );
  }

  //
  factory Inbox.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Inbox(
      id: id,
      author: json['author'] as String?,
      item: json['item'] as String?,
      itmid: json['itmid'] as String?,
      type: json['type'] as String?,
      itmdate: json['date'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }
}
