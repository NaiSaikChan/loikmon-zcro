import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/Books.dart';

class Sliders {
  final String? link, thumbnail, type;
  final Object? item;

  Sliders({
    this.link,
    this.thumbnail,
    this.item,
    this.type,
  });

  factory Sliders.fromJson(Map<String, dynamic> json) {
    Object? itm;
    String type = json['type'] as String;
    if (type == "author") {
      if (json['item'] != null) {
        itm = Authors.fromJson(json['item']);
      }
    }
    if (type == "ebook") {
      if (json['item'] != null) {
        itm = Books.fromJson(json['item']);
      }
    }
    if (type == "article") {
      if (json['item'] != null) {
        itm = Articles.fromJson(json['item']);
      }
    }
    return Sliders(
      link: json['link'] as String,
      thumbnail: json['thumbnail'] as String,
      type: type,
      item: itm,
    );
  }
}
