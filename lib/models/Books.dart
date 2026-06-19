class Books {
  final int? id, authorid;
  final String? title,
      thumbnail,
      coverphoto,
      book,
      epub,
      publisher,
      audioduration;
  final String? author,
      description,
      pages,
      categoryname,
      type,
      product,
      datepublished;
  final double? amount;
  final double? rates, hasrate;
  final int? sales, views;
  final int? pdfhttp;
  final int? epubhttp;
  final bool? hasAudio; // Updated to BOOL
  final String? rating, seller, messenger, phone1, phone2;

  static const String BOOKMARKS = "booksbookmarks";
  static const String DOWNLOADS = "booksdownloads";

  static final columns = [
    "bookid",
    "seller",
    "authorid",
    "title",
    "thumbnail",
    "coverphoto",
    "book",
    "epub",
    "publisher",
    "author",
    "description",
    'type',
    "pages",
    "categoryname",
    "amount",
    "rates",
    "views",
    "sales",
    "hasrate",
    "pdfhttp",
    "epubhttp",
    "product",
    "datepublished",
    "rating",
    "messenger",
    "phone1",
    "phone2",
    "hasAudio", // stored as INTEGER in SQLite: 0/1
    "audioduration",
  ];

  Books({
    this.id,
    this.authorid,
    this.seller,
    this.title,
    this.thumbnail,
    this.coverphoto,
    this.book,
    this.epub,
    this.publisher,
    this.author,
    this.description,
    this.type,
    this.pages,
    this.categoryname,
    this.amount,
    this.rates,
    this.sales,
    this.views,
    this.hasrate,
    this.pdfhttp,
    this.epubhttp,
    this.product,
    this.datepublished,
    this.rating,
    this.messenger,
    this.phone1,
    this.phone2,
    this.hasAudio, //
    this.audioduration,
  });

  // Converts any type to bool safely
  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) {
      return v == "1" || v.toLowerCase() == "true";
    }
    return false;
  }

  // API → Model
  factory Books.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['id'].toString());
    int authorid = int.parse(json['authorid'].toString());
    double amount = double.parse(json['amount'].toString());
    int sales = int.parse(json['itmsales'].toString());

    return Books(
      id: id,
      authorid: authorid,
      seller: json['seller'] as String?,
      title: json['title'] as String?,
      thumbnail: json['thumbnail'] as String?,
      coverphoto: json['coverphoto'] as String?,
      book: json['pdf'] as String?,
      epub: json['epub'] as String?,
      publisher: json['publisher'] as String?,
      author: json['authorname'] as String?,
      description: json['description'] as String?,
      pages: json['pages'] as String?,
      categoryname: json['categoryname'] as String?,
      product: json['productid'] == null ? "" : json['productid'] as String?,
      datepublished: json['publishdate'] as String?,
      messenger: json['contact'] as String?,
      phone1: json['phone1'] as String?,
      phone2: json['phone2'] as String?,
      rating: json['rating'] == null ? "0" : json['rating'] as String?,
      amount: amount,
      sales: sales,
      rates: 0,
      hasrate: 0,
      views: int.parse(json['views'].toString()),
      pdfhttp: 0,
      epubhttp: 0,
      type: "",
      hasAudio: _toBool(json['has_audio']), // bool parser
      audioduration:
          json['audioduration'] == null ? "" : json['audioduration'] as String,
    );
  }

  // SQLite Row → Model
  factory Books.fromMap(Map<String, dynamic> data) {
    return Books(
      id: data['bookid'],
      authorid: data['authorid'],
      seller: data['seller'],
      title: data['title'],
      thumbnail: data['thumbnail'],
      coverphoto: data['coverphoto'],
      book: data['book'],
      epub: data['epub'],
      publisher: data['publisher'],
      author: data['author'],
      description: data['description'],
      pages: data['pages'],
      categoryname: data['categoryname'],
      amount: data['amount'],
      rates: data['rates'],
      views: data['views'],
      sales: data['sales'],
      hasrate: data['hasrate'],
      type: data['type'],
      pdfhttp: data['pdfhttp'],
      epubhttp: data['epubhttp'],
      product: data['product'],
      datepublished: data['datepublished'],
      rating: data['rating'],
      messenger: data['messenger'],
      phone1: data['phone1'],
      phone2: data['phone2'],
      hasAudio: data['hasAudio'] == 1, // INTEGER → bool
      audioduration: data['audioduration'],
    );
  }

  // Model → SQLite
  Map<String, dynamic> toMap() => {
        "bookid": id,
        "authorid": authorid,
        "seller": seller,
        "title": title,
        "thumbnail": thumbnail,
        "coverphoto": coverphoto,
        "book": book,
        "epub": epub,
        "publisher": publisher,
        "author": author,
        "description": description,
        "pages": pages,
        "categoryname": categoryname,
        "amount": amount,
        "rates": rates,
        "views": views,
        "sales": sales,
        "hasrate": hasrate,
        "type": type,
        "pdfhttp": pdfhttp,
        "epubhttp": epubhttp,
        "product": product,
        "datepublished": datepublished,
        "rating": rating,
        "messenger": messenger,
        "phone1": phone1,
        "phone2": phone2,
        "hasAudio": hasAudio == true ? 1 : 0, // bool → INTEGER
        "audioduration": audioduration,
      };

  Map<String, dynamic> toMap2(double _amount) => {
        "bookid": id,
        "authorid": authorid,
        "seller": seller,
        "title": title,
        "thumbnail": thumbnail,
        "coverphoto": coverphoto,
        "book": book,
        "epub": epub,
        "publisher": publisher,
        "author": author,
        "description": description,
        "pages": pages,
        "categoryname": categoryname,
        "amount": _amount,
        "rates": rates,
        "views": views,
        "sales": sales,
        "hasrate": hasrate,
        "type": type,
        "pdfhttp": pdfhttp,
        "epubhttp": epubhttp,
        "product": product,
        "datepublished": datepublished,
        "rating": rating,
        "messenger": messenger,
        "phone1": phone1,
        "phone2": phone2,
        "hasAudio": hasAudio == true ? 1 : 0, // bool → INTEGER
        "audioduration": audioduration,
      };

  // Copy Constructor for downloaded books
  factory Books.fromBook(
      Books? books, String pdf, String epub, int pdfhttp, int epubhttp) {
    return Books(
      id: books!.id,
      authorid: books.authorid,
      seller: books.seller,
      title: books.title,
      thumbnail: books.thumbnail,
      coverphoto: books.coverphoto,
      book: pdf,
      epub: epub,
      publisher: books.publisher,
      author: books.author,
      description: books.description,
      pages: books.pages,
      categoryname: books.categoryname,
      amount: books.amount,
      rates: books.rates,
      views: books.views,
      hasrate: books.hasrate,
      sales: books.sales,
      type: books.type,
      product: books.product,
      pdfhttp: pdfhttp,
      epubhttp: epubhttp,
      datepublished: books.datepublished,
      rating: books.rating,
      messenger: books.messenger,
      phone1: books.phone1,
      phone2: books.phone2,
      hasAudio: books.hasAudio, //preserve bool
      audioduration: books.audioduration,
    );
  }
}
