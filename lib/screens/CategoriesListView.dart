import 'package:flutter/material.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/CategoriesViewScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';

class CategoriesListView extends StatelessWidget {
  CategoriesListView(this.categories);
  final List<Categories> categories;

  Widget _buildItems(BuildContext context, int index) {
    var cats = categories[index];

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CategoriesViewScreen.routeName,
            arguments:
                new ScreenArguements(items: Itms(cats.id, cats.title, 0)));
      },
      child: Container(
        height: 45,
        //width: 100,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 3,
          bottom: 0,
        ),

        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(3)),
            // color: const Color.fromARGB(31, 136, 137, 138),
            border: Border.all(
              color: const Color.fromARGB(255, 114, 113, 114),
              width: 2,

              //strokeAlign: BorderSide.strokeAlignOutside,
            )),
        child: Center(
          child: Text(
            cats.title!,
            style: TextStyles.display1(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              //fontFamily: 'style1'
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.0, left: 0.0),
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: categories.length,
        itemBuilder: _buildItems,
      ),
    );
  }
}
