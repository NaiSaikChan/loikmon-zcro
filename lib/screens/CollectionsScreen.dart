import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/models/Collections.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/CollectionDetailsScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/ApiUrl.dart';
import 'NoitemScreen.dart';

class CollectionsScreen extends StatefulWidget {
  static const routeName = "/CollectionsScreen";

  @override
  _CollectionsScreenState createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  List<Collections> items = [];
  bool isError = false;
  int page = 0;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  void fetchItems({bool isRefresh = true}) async {
    try {
      if (isRefresh) page = 0;

      final response = await http.post(
        Uri.parse(ApiUrl.FETCH_COLLECTIONS),
        body: jsonEncode({
          "data": {"page": page.toString()}
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final parsed = res["collections"].cast<Map<String, dynamic>>();

        List<Collections> newItems = parsed
            .map<Collections>((json) => Collections.fromJson(json))
            .toList();

        setState(() {
          isError = false;

          if (page == 0) {
            items = newItems;
          } else {
            items.addAll(newItems);
          }
        });

        refreshController.refreshCompleted();
        refreshController.loadComplete();
      } else {
        setFetchError();
      }
    } catch (e) {
      print(e);
      setFetchError();
    }
  }

  void setFetchError() {
    setState(() => isError = true);
    refreshController.refreshFailed();
    refreshController.loadFailed();
  }

  void onRefresh() {
    fetchItems(isRefresh: true);
  }

  void onLoading() {
    page++;
    fetchItems(isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Collections",
          style: TextStyles.display1(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (context, mode) {
              if (mode == LoadStatus.loading) {
                return CupertinoActivityIndicator();
              }
              return Text("No more data");
            },
          ),
          child: (isError && items.isEmpty)
              ? NoitemScreen(
                  title: "Oops",
                  message: "Failed to load collections",
                  onClick: onRefresh,
                )
              : GridView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Utility.getItemCount(context),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          Utility.getItemchildAspectRatio(context)),
                  itemBuilder: (context, index) {
                    var item = items[index];

                    return InkWell(
                      onTap: () {
                        // TODO: open collection details
                        Navigator.pushNamed(
                            context, CollectionDetailsScreen.routeName,
                            arguments: ScreenArguements(
                              position: item.id,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // ✅ IMAGE
                              Positioned.fill(
                                child: Image.network(
                                  item.coverImage ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // ✅ DARK GRADIENT OVERLAY
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.75),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ✅ TEXT AT BOTTOM
                              Positioned(
                                left: 10,
                                right: 10,
                                bottom: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyles.display1(context).copyWith(
                                        color: const Color.fromARGB(
                                            255, 243, 241, 241),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "${item.bookCount ?? 0} books",
                                      style:
                                          TextStyles.display1(context).copyWith(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
