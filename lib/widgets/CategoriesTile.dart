import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/CategoriesViewScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';

class CategoriesTile extends StatelessWidget {
  final Categories categories;
  final int index;

  const CategoriesTile({
    Key? key,
    required this.index,
    required this.categories,
  }) : super(key: key);

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
                      imageUrl: categories.thumbnailUrl!,
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
                left: 1,
                right: 1,
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
                          categories.title!,
                          style: TextStyles.display1(context).copyWith(
                            color: const Color.fromARGB(255, 246, 245, 245),
                            // fontWeight: FontWeight.bold,
                            //fontFamily: 'style2',
                            fontSize: 20.0,
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
                                    categories.articlescount.toString() +
                                    ' ' +
                                    t.articless,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 244, 243, 243),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                t.bookss +
                                    ' ' +
                                    categories.bookscount.toString() +
                                    ' ' +
                                    t.booksss,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyles.display1(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
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
          Navigator.of(context).pushNamed(CategoriesViewScreen.routeName,
              arguments: new ScreenArguements(
                  items: Itms(categories.id, categories.title, 0)));
        },
      ),
    );
  }
}
