import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../models/Books.dart';
import '../utils/ApiUrl.dart';

class CollectionDetailsScreen extends StatefulWidget {
  static const routeName = "/CollectionsDetailsScreen";
  final int collectionId;

  CollectionDetailsScreen({required this.collectionId});

  @override
  _CollectionDetailsScreenState createState() =>
      _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState extends State<CollectionDetailsScreen> {
  bool isLoading = true;
  dynamic collection;
  List<Books> books = [];

  Future<void> shareCollection() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;

    String text = "📚 ${collection["title"]}\n"
        "Explore this amazing book collection on Loik Mon.\n\n"
        "http://play.google.com/store/apps/details?id=$packageName";

    await Share.share(
      text,
      subject: "${collection["title"]}",
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCollection();
  }

  fetchCollection() async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.fetchSingleCollection),
        body: jsonEncode({
          "data": {"collection_id": widget.collectionId}
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);

        setState(() {
          collection = res["collection"];
          books = (res["books"] as List).map((e) => Books.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 100, right: 100, top: 0),
        child: CustomScrollView(
          slivers: [
            // 🔥 APP BAR IMAGE
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      collection["cover_image"],
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: share collection
                    if (collection != null) {
                      shareCollection();
                    }
                  },
                )
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      collection["title"] ?? "",
                      style: TextStyles.display1(context).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    // DESCRIPTION
                    Text(
                      collection["description"] ?? "",
                      style:
                          TextStyles.display1(context).copyWith(fontSize: 14),
                    ),

                    SizedBox(height: 20),

                    // BOOK COUNT
                    Text(
                      "${books.length} books",
                      style: TextStyles.display1(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 10),

                    Divider(),

                    SizedBox(height: 10),

                    Text(
                      "Book List",
                      style: TextStyles.display1(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // 🔥 BOOK LIST
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var book = books[index];

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        book.thumbnail ?? "",
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(book.title ?? ""),
                    subtitle: Text(book.author ?? ""),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: open book
                      Navigator.pushNamed(context, EbooksViewerScreen.routeName,
                          arguments: ScreenArguements(
                            position: 0,
                            items: book,
                            check: false,
                          ));
                    },
                  );
                },
                childCount: books.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
