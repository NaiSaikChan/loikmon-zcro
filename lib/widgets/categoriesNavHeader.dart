import 'package:flutter/material.dart';

import '../providers/ArticlesModel.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

Widget categoriesNavHeader(ArticlesModel articlesmodel) {
  return Container(
    height: 40,
    margin: EdgeInsets.only(left: 10, right: 10),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      //itemExtent: 100,
      itemCount: articlesmodel.categories.length,
      itemBuilder: (context, index) {
        bool selected =
            articlesmodel.isSelected(articlesmodel.categories[index]);
        return Container(
          //width: 80,
          child: InkWell(
            onTap: () {
              articlesmodel.selectCategory(articlesmodel.categories[index]);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: selected
                            ? BorderSide(
                                color: MyColors.mainC0lor,
                              )
                            : BorderSide.none)),
                padding: EdgeInsets.only(left: 2, right: 5),
                child: Text(articlesmodel.categories[index].title!,
                    style: TextStyles.display5(context).copyWith(
                        // fontFamily: "style2",
                        fontSize: selected ? 17 : 17,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal),
                    selectionColor:
                        selected ? MyColors.mainC0lor : MyColors.primaryLight),
              ),
            ),
          ),
        );
      },
    ),
  );
}
