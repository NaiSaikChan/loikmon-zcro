class Faqs {
  final String? name, content;

  Faqs(
    this.name,
    this.content,
  );

  factory Faqs.fromJson(Map<String, dynamic> json) {
    return Faqs(
      json['name'] as String?,
      json['content'] as String?,
    );
  }
}
