class Authors {
  final int? id;
  final String? name, email, education, description, thumbnail, type;
  final int? bookscount, articlescount, posts, likes, followers;
  bool? isfollowing;
  final String? facebook, instagram, youtube;

  Authors({
    this.id,
    this.name,
    this.type,
    this.email,
    this.education,
    this.description,
    this.thumbnail,
    this.bookscount,
    this.articlescount,
    this.posts,
    this.likes,
    this.followers,
    this.isfollowing,
    this.facebook,
    this.instagram,
    this.youtube,
  });

  int get totalContents => (bookscount ?? 0) + (articlescount ?? 0);

  factory Authors.fromJson(Map<String, dynamic> json) {
    int id = int.tryParse(json['id'].toString()) ?? 0;
    int bookscount = int.tryParse(json['bookscount'].toString()) ?? 0;
    int articlescount = int.tryParse(json['articlescount'].toString()) ?? 0;
    int posts = int.tryParse(json['posts'].toString()) ?? 0;
    int likes = int.tryParse(json['likes'].toString()) ?? 0;
    int followers = int.tryParse(json['followers'].toString()) ?? 0;
    int isfollowing = int.tryParse(json['isfollowing'].toString()) ?? 0;

    return Authors(
      id: id,
      name: json['name'] as String?,
      type: json['type'] as String?,
      email: json['email'] as String?,
      education: json['education'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      bookscount: bookscount,
      articlescount: articlescount,
      posts: posts,
      likes: likes,
      followers: followers,
      isfollowing: isfollowing == 1,
      facebook: json['facebook'] as String?,
      youtube: json['youtube'] as String?,
      instagram: json['instagram'] as String?,
    );
  }
}