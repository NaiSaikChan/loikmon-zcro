import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../models/ScreenArguements.dart';

class ArticlesListView extends StatefulWidget {
  ArticlesListView(this.books);
  final List<Articles> books;

  @override
  State<ArticlesListView> createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  bool? get isdarkmode => null;

  Widget _buildItems(BuildContext context, int index) {
    var cats = widget.books[index];

    var coins = LineAwesomeIcons.coins_solid;
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
        child: Container(
          height: 210.0,
          width: 240.0,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            color: Colors.black12,
          ),
          child: Column(
            children: <Widget>[
              Stack(children: [
                Container(
                  height: 150,
                  //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: cats.thumbnail!,
                      imageBuilder: (context, imageProvider) => Container(
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
              ]),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                //  child: MarqueeWidget(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    cats.title!,
                    style: TextStyles.display1(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      //fontFamily: 'Style2',
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
                // ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(cats.author!,
                    style: TextStyles.display5(context).copyWith(
                      fontSize: 14,
                    )),
                // child: Text(
                //   cats.author!,
                //   style: TextStyle(
                //     //fontWeight: FontWeight.bold,
                //     fontSize: 15.0,
                //     //fontFamily: 'Style1',
                //   ),
                //   maxLines: 1,
                //   textAlign: TextAlign.left,
                // ),
              ),
              Container(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingStars(
                      value: double.parse(cats.rating!),
                      onValueChanged: (v) {},
                      starBuilder: (index, color) => Icon(
                        Icons.star,
                        color: color,
                        size: 15,
                      ),
                      starCount: 5,
                      starSize: 15,
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: TextStyles.display1(context)
                          .copyWith(
                              color: const Color.fromARGB(255, 242, 240, 240),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 0.0),
                      valueLabelRadius: 0,
                      maxValue: 5,
                      starSpacing: 2,
                      //maxValueVisibility: true,
                      valueLabelVisibility: true,
                      animationDuration: Duration(milliseconds: 1000),
                      valueLabelPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      valueLabelMargin: const EdgeInsets.only(right: 0),
                      starOffColor: Colors.grey,
                      starColor: Colors.orange,
                    ),
                    Spacer(),
                    Visibility(
                      visible: cats.streamUrl != "",
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Icon(
                          LineAwesomeIcons.volume_up_solid,
                          // color: Colors.orange[900],
                          size: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            coins,
                            color: Colors.orange,
                            size: 15,
                          ),
                          Text(
                            cats.amount.toString(),
                            style: TextStyles.display1(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: "",
                              color: MyColors.mainC0lor,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, ArticleViewerScreen.routeName,
              arguments: ScreenArguements(
                position: index,
                items: cats,
                check: false,
                itemsList: widget.books,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 10.0),
      height: 240.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: widget.books.length,
        itemBuilder: _buildItems,
      ),
    );
  }
}
