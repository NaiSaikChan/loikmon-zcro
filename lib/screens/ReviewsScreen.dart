import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Reviews.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/CommentsModel.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/widgets/CommentsItem.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screens/NoitemScreen.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = "/ReviewsScreen";
  ReviewsScreen(this.books);
  final Books? books;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return ChangeNotifierProvider(
      create: (context) => CommentsModel(context, widget.books!.id!, 0, false),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text(
            t.reviews,
            maxLines: 1,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              /*Visibility(
                visible: appStateManager.userdata != null,
                child: Consumer<CommentsModel>(
                    builder: (context, commentsmodel, child) {
                  return InkWell(
                    onTap: () async {
                      final _dialog = RatingDialog(
                        initialRating: 1.0,
                        // your app's name?
                        title: Text(
                          'Rate ' + widget.books!.title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        // encourage your user to leave a high rating?
                        message: Text(
                          'Tap a star to set your rating',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                        // your app's logo?
                        image: Container(
                          height: 120,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.books!.thumbnail!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                Icons.error,
                                color: Colors.grey,
                              )),
                            ),
                          ),
                        ),
                        submitButtonText: 'Submit',
                        initialtext: "",
                        commentHint: 'add a comment',
                        onCancelled: () => print('cancelled'),
                        onSubmitted: (response) {
                          print(
                              'rating: ${response.rating}, comment: ${response.comment}');
                          commentsmodel.constructComment(
                              context, response.comment, response.rating);
                        },
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        barrierDismissible:
                            true, // set to false if you want to force a rating
                        builder: (context) => _dialog,
                      );
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          //height: 25,
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 15,
                          ),
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 6,
                            bottom: 6,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: MyColors.mainC0lor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Text(
                            "Write a review",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  );
                }),
              ),*/
              Container(
                padding: const EdgeInsets.all(0),
                margin: EdgeInsets.only(bottom: 10),
                height: 80,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      left: 30,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          //color: Colors.white,
                        ),
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.books!.title!,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.books!.author!,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 60,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            image: DecorationImage(
                              image: NetworkImage(widget.books!.thumbnail!),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    Positioned(bottom: 0, left: 0, right: 0, child: Divider()),
                  ],
                ),
              ),
              Expanded(child: CategoryScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<CategoryScreen> {
  CommentsModel? authorsModel;
  List<Reviews?>? commentsList;

  void _onRefresh() async {
    authorsModel!.loadItems();
  }

  void _onLoading() async {
    authorsModel!.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<CommentsModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    authorsModel = Provider.of<CommentsModel>(context);
    commentsList = authorsModel!.items;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: authorsModel!.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (authorsModel!.isError == true && commentsList!.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.separated(
              shrinkWrap: true,
              itemCount: commentsList!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                int _index = index;
                print(commentsList![_index]!.content!);
                return CommentsItem(
                  context: context,
                  index: _index,
                  object: commentsList![_index]!,
                );
              },
            ),
    );
  }
}
