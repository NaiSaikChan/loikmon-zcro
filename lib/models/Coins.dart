class Coins {
  final String? name, productid;
  int? id;
  int? amount, value;

  Coins(
    this.id,
    this.name,
    this.productid,
    this.amount,
    this.value,
  );

  factory Coins.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Coins(
      id,
      json['name'] as String?,
      json['productid'] as String?,
      int.parse(json['amount'].toString()),
      int.parse(json['value'].toString()),
    );
  }
}
