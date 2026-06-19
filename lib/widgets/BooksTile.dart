import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/SubscriptionModel.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/utils/MarqueeWidget.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BooksTile extends StatefulWidget {
  final Books? books;
  final int? index;
  final bool? isdownloads;

  const BooksTile(
    this.isdownloads, {
    Key? key,
    this.index,
    this.books,
  })  : assert(index != null),
        assert(books != null),
        super(key: key);

  @override
  State<BooksTile> createState() => _BooksTileState();
}

class _BooksTileState extends State<BooksTile> {
  double value = 3.5;

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateNotifier = Provider.of<AppStateManager>(context);
    bool ispurchased = appStateNotifier.isBookPurchased(widget.books!.id!);
    SubscriptionModel subscriptionModel =
        Provider.of<SubscriptionModel>(context);
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        child: Container(
          height: 380.0,
          width: 165.0,
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              color: Colors.black12,
              border:
                  Border.all(color: const Color.fromARGB(115, 164, 162, 162))
              /*boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],*/
              ),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    height: 290,
                    //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6)),
                      child: CachedNetworkImage(
                        imageUrl: widget.books!.thumbnail!,
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
                  Visibility(
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3, bottom: 0),
                        //width: 60,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          widget.index.toString(),
                          style: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            //fontFamily: "",
                            color: MyColors.white,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                child: MarqueeWidget(
                  child: Text(
                    widget.books!.title!,
                    style: TextStyles.display1(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.books!.author!,
                  style: TextStyles.display1(context).copyWith(
                    //fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingStars(
                      value: double.parse(widget.books!.rating!),
                      onValueChanged: (v) {},
                      starBuilder: (index, color) => Icon(
                        Icons.star,
                        color: color,
                        size: 15,
                      ),
                      starCount: 5,
                      starSize: 15,
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: const TextStyle(
                          color: Colors.white,
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
                    Row(
                      children: [
                        Visibility(
                          visible: widget.books!.hasAudio!,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Icon(
                              LineAwesomeIcons.volume_up_solid,
                              // color: Colors.orange[900],
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                LineAwesomeIcons.coins_solid,
                                color: Colors.orange,
                                size: 17,
                              ),
                              Text(
                                widget.books!.amount.toString(),
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
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
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, EbooksViewerScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: widget.books,
                check: widget.isdownloads,
              ));
        },
      ),
    );
  }
}
