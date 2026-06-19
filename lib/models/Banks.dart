class Banks {
  final int? id;
  final String? bankname, accountname;
  final String? accountnumber, routingcode, address;
  final String? thumbnail, details;

  Banks({
    this.id,
    this.bankname,
    this.accountname,
    this.accountnumber,
    this.routingcode,
    this.address,
    this.thumbnail,
    this.details,
  });

  factory Banks.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Banks(
      id: id,
      bankname: json['bankname'] as String?,
      accountname: json['accountname'] as String?,
      accountnumber: json['accountnumber'] as String?,
      routingcode: json['routingcode'] as String?,
      address: json['address'] as String?,
      thumbnail: json['thumbnail'] as String?,
      details: json['details'] as String?,
    );
  }
}
