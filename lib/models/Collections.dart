class Collections {
  int? id;
  String? title;
  String? description;
  String? coverImage;
  int? bookCount;

  Collections({
    this.id,
    this.title,
    this.description,
    this.coverImage,
    this.bookCount,
  });

  factory Collections.fromJson(Map<String, dynamic> json) {
    print(json['cover_image']);
    return Collections(
      id: int.tryParse(json['id'].toString()),
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      bookCount: int.tryParse(json['book_count'].toString()),
    );
  }
}
