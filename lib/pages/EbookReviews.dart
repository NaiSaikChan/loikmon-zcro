import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Reviews.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/CommentsModel.dart';
import 'package:loikmon/screens/EmptyListScreen.dart';
import 'package:loikmon/screens/ReviewsScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/widgets/CommentsItem.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class EbookReviews extends StatefulWidget {
  static const routeName = "/EbooksViewerScreen";
  EbookReviews(this.books);
  final Books? books;

  @override
  _EbookReviewsState createState() => _EbookReviewsState();
}

class _EbookReviewsState extends State<EbookReviews> {
  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return ChangeNotifierProvider(
        create: (context) => CommentsModel(context, widget.books!.id!, 0, true),
        child: ListView(
          children: [
            Visibility(
              visible: appStateManager.userdata != null,
              child: Consumer<CommentsModel>(
                  builder: (context, commentsmodel, child) {
                return Visibility(
                  visible: !commentsmodel.isuserreviewed,
                  child: InkWell(
                    onTap: () async {
                      final _dialog = RatingDialog(
                        initialRating: 1.0,
                        // your app's name?
                        title: Text(
                          t.rate + ' ' + widget.books!.title!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 20,
                          ),
                        ),
                        // encourage your user to leave a high rating?
                        message: Text(
                          t.taptorate,
                          textAlign: TextAlign.center,
                          style: TextStyles.display1(context)
                              .copyWith(fontSize: 17),
                        ),
                        // your app's logo?
                        image: Container(
                          height: 120,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
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
                        submitButtonText: t.submit,
                        submitButtonTextStyle:
                            TextStyles.display1(context).copyWith(
                          fontSize: 20,
                        ),
                        // initialtext: "",
                        commentHint: t.addcomment, starSize: 23,
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
                    child: Container(
                        //height: 25,
                        margin: EdgeInsets.only(
                          top: 15,
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
                          t.writeareview,
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                );
              }),
            ),
            Consumer<CommentsModel>(builder: (context, commentsmodel, child) {
              return Container(
                //height: 40,
                padding: const EdgeInsets.only(
                    left: 20, right: 0, top: 13, bottom: 14),
                child: Row(
                  children: <Widget>[
                    Visibility(
                      visible: commentsmodel.items.length > 0,
                      child: Expanded(
                        child: Text(
                          t.topreviews,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: commentsmodel.items.length > 4,
                      child: MaterialButton(
                        elevation: 0,
                        textColor: Colors.white,
                        color: MyColors.mainC0lor,
                        height: 0,
                        child: Icon(Icons.keyboard_arrow_right),
                        minWidth: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ReviewsScreen.routeName,
                              arguments: ScreenArguements(items: widget.books));
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
            EbookReviewsbody(),
          ],
        ));
  }
}

class EbookReviewsbody extends StatelessWidget {
  const EbookReviewsbody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentsModel = Provider.of<CommentsModel>(context);
    List<Reviews> commentsList = commentsModel.items;
    if (commentsModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (commentsList.length == 0) {
      return Container(
          height: 100, child: EmptyListScreen(message: t.noreviews));
    } else {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: commentsList.length,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          int _index = index;
          print(commentsList[_index].content);
          return CommentsItem(
            context: context,
            index: _index,
            object: commentsList[_index],
          );
        },
      );
    }
  }
}
