class Articles {
  final int? id, views, amount;
  final String? title,
      description,
      content,
      thumbnail,
      thumbnail2,
      thumbnail3,
      thumbnail4,
      thumbnail5;
  final String? author, category, date, link, rating, streamUrl;
  final double? rates, hasrate;

  static const String BOOKMARKS = "articlesbookmarks";
  static const String DOWNLOADS = "articlesdownloads";
  static final columns = [
    "id",
    "title",
    "content",
    "description",
    "thumbnail",
    "thumbnail2",
    "thumbnail3",
    "thumbnail4",
    "thumbnail5",
    "author",
    "category",
    "date",
    "link",
    "views",
    "amount",
    "rates",
    "hasrate",
    "rating",
    "streamUrl",
  ];

  Articles({
    this.id,
    this.title,
    this.author,
    this.description,
    this.category,
    this.thumbnail,
    this.thumbnail2,
    this.thumbnail3,
    this.thumbnail4,
    this.thumbnail5,
    this.content,
    this.date,
    this.views,
    this.link,
    this.amount,
    this.hasrate,
    this.rates,
    this.rating,
    this.streamUrl,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int views = int.parse(json['views'].toString());
    int amount = int.parse(json['amount'].toString());
    return Articles(
      id: id,
      title: json['title'] as String?,
      category: json['categoryname'] as String?,
      thumbnail: json['thumbnail'] as String?,
      thumbnail2: json['thumbnail2'] as String?,
      thumbnail3: json['thumbnail3'] as String?,
      thumbnail4: json['thumbnail4'] as String?,
      thumbnail5: json['thumbnail5'] as String?,
      author: json['authorname'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      date: json['date'] as String?,
      link: json['link'] as String?,
      streamUrl: json['audio'] as String?,
      rating: json['rating'] == null ? "0" : json['rating'] as String?,
      views: views,
      amount: amount,
      rates: 0,
      hasrate: 0,
    );
  }

  factory Articles.fromMap(Map<String, dynamic> data) {
    return Articles(
      id: data['id'],
      title: data['title'],
      author: data['author'],
      category: data['category'],
      description: data['description'],
      thumbnail: data['thumbnail'],
      thumbnail2: data['thumbnail2'],
      thumbnail3: data['thumbnail3'],
      thumbnail4: data['thumbnail4'],
      thumbnail5: data['thumbnail5'],
      content: data['content'],
      date: data['date'],
      views: data['views'],
      link: data['link'],
      amount: data['amount'],
      hasrate: data['hasrate'],
      rates: data['rates'],
      rating: data['rating'],
      streamUrl: data['streamUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "author": author,
        "category": category,
        "thumbnail": thumbnail,
        "thumbnail2": thumbnail2,
        "thumbnail3": thumbnail3,
        "thumbnail4": thumbnail4,
        "thumbnail5": thumbnail5,
        "description": description,
        "content": content,
        "date": date,
        "views": views,
        "link": link,
        "amount": amount,
        "rates": rates,
        "hasrate": hasrate,
        "rating": rating,
        "streamUrl": streamUrl,
      };

  Map<String, dynamic> toMap2(int _amount) => {
        "id": id,
        "title": title,
        "author": author,
        "category": category,
        "thumbnail": thumbnail,
        "thumbnail2": thumbnail2,
        "thumbnail3": thumbnail3,
        "thumbnail4": thumbnail4,
        "thumbnail5": thumbnail5,
        "description": description,
        "content": content,
        "date": date,
        "views": views,
        "link": link,
        "rates": rates,
        "hasrate": hasrate,
        "amount": _amount,
        "rating": rating,
        "streamUrl": streamUrl,
      };
}
