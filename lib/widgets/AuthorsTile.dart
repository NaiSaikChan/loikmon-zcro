import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';

class AuthorsTile extends StatefulWidget {
  final Authors categories;
  final int index;

  const AuthorsTile({
    Key? key,
    required this.index,
    required this.categories,
  }) : super(key: key);

  @override
  State<AuthorsTile> createState() => _AuthorsTileState();
}

class _AuthorsTileState extends State<AuthorsTile> {
  bool isfollowing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        isfollowing = widget.categories.isfollowing!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: InkWell(
        child: Container(
          // height: 250.0,
          width: 120.0,
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 3,
                child: Container(
                  //height: 160,
                  //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: CachedNetworkImage(
                      imageUrl: widget.categories.thumbnail!,
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
              ),
              Positioned(
                bottom: 5,
                left: 5,
                right: 5,
                child: Container(
                  color: Colors.black54,
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.categories.name!,
                          style: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: const Color.fromARGB(255, 246, 244, 244),
                          ),
                          // maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                t.articlesss +
                                    ' ' +
                                    widget.categories.articlescount.toString() +
                                    ' ' +
                                    t.articless,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color:
                                      const Color.fromARGB(255, 246, 244, 244),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                t.bookss +
                                    ' ' +
                                    widget.categories.bookscount.toString() +
                                    ' ' +
                                    t.booksss,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color:
                                      const Color.fromARGB(255, 246, 244, 244),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, AuthorsListScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: widget.categories,
                check: isfollowing,
              ));
        },
      ),
    );
  }
}
