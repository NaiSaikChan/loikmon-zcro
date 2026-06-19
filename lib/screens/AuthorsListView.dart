import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/utils/MarqueeWidget.dart';

class AuthorsListView extends StatelessWidget {
  AuthorsListView(this.authors);
  final List<Authors> authors;

  Widget _buildItems(BuildContext context, int index) {
    var cats = authors[index];

    return Container(
      height: 200.0,
      width: 185.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(3),
              bottomRight: Radius.circular(3)),
          //color: const Color.fromARGB(31, 43, 21, 43),
          border: Border.all(
            color: const Color.fromARGB(255, 126, 126, 126),
            width: 2,
            //strokeAlign: BorderSide.strokeAlignOutside,
          )),
      child: InkWell(
        child: Column(
          children: [
            Container(
              height: 164,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(10.0)),
                    //     border: Border.all(
                    //       // color: MyColors.mainC0lor,
                    //       width: 2,
                    //       //strokeAlign: BorderSide.strokeAlignOutside,
                    //     )),
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        //height: 80,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
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
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 3),
              child: MarqueeWidget(
                  child: Text(cats.name!,
                      maxLines: 1,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600
                          //fontFamily: 'style1'
                          ))),
            )
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, AuthorsListScreen.routeName,
              arguments: ScreenArguements(
                position: 0,
                items: authors[index],
                check: authors[index].isfollowing,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.0, left: 10.0),
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: authors.length,
        itemBuilder: _buildItems,
      ),
    );
  }
}
