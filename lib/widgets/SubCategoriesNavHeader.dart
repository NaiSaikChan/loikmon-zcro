import 'package:flutter/material.dart';
import 'package:loikmon/models/Categories.dart';

import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

Widget SubCategoriesNavHeader(
    List<Categories> categories, Function isselected, Function callback) {
  return Container(
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      //itemExtent: 100,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        bool selected = isselected(index);
        return Container(
          //width: 80,
          child: InkWell(
            onTap: () {
              callback(categories[index].id);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: selected
                            ? BorderSide(color: MyColors.mainC0lor)
                            : BorderSide.none)),
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text(categories[index].title!,
                    style: TextStyles.display5(context).copyWith(
                        //fontFamily: "Style1",
                        fontSize: selected ? 17 : 17,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal)),
              ),
            ),
          ),
        );
      },
    ),
  );
}
