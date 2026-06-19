import 'package:flutter/material.dart';
import 'package:loikmon/providers/OtherbooksModel.dart';

import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';

Widget categoriesBooksHeader(OtherbooksModel otherbooksModel) {
  return Container(
    height: 40,
    margin: EdgeInsets.only(left: 10, right: 10),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      //itemExtent: 100,
      itemCount: otherbooksModel.categories.length,
      itemBuilder: (context, index) {
        bool selected =
            otherbooksModel.isSelected(otherbooksModel.categories[index]);
        return Container(
          //width: 80,
          child: InkWell(
            onTap: () {
              otherbooksModel.selectCategory(otherbooksModel.categories[index]);
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
                child: Text(otherbooksModel.categories[index].title!,
                    style: TextStyles.display5(context).copyWith(
                        //fontFamily: "serif",
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
