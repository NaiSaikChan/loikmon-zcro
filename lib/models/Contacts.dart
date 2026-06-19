class Contacts {
  final String? contacttitle,
      contactdescription,
      contactusphone1,
      contactusphone2,
      contactusmessenger;

  Contacts(
    this.contacttitle,
    this.contactdescription,
    this.contactusphone1,
    this.contactusphone2,
    this.contactusmessenger,
  );

  factory Contacts.fromJson(Map<String, dynamic> json) {
    //print(json);
    return Contacts(
      json['contacttitle'] as String?,
      json['contactdescription'] as String?,
      json['contactusphone1'] as String?,
      json['contactusphone2'] as String?,
      json['contactusmessengerweb'] as String?,
    );
  }
}
