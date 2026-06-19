import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:lottie/lottie.dart';

import '../utils/my_colors.dart';

class NoitemScreen extends StatelessWidget {
  final String title;
  final String message;
  final Function onClick;

  const NoitemScreen({
    Key? key,
    required this.title,
    required this.message,
    required this.onClick,
  }) : super(key: key);

  void onItemClick() {
    onClick();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              onItemClick();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Text(title,
                    style: TextStyles.display1(context).copyWith(
                        //color: MyColors.primary,
                        fontWeight: FontWeight.bold)),
                Container(height: 10),*/
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
                  child: Lottie.asset(
                    "assets/lottie/network.json",
                    width: 400,
                    height: 400,
                  ), //Image.asset(Img.get(onboarder.image),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyles.display1(context).copyWith(
                          //color: MyColors.primary
                          fontSize: 12)),
                ),
                Container(height: 25),
                Container(
                  width: 180,
                  height: 40,
                  child: TextButton(
                    child: Text(t.retry,
                        style: TextStyles.display1(context).copyWith(
                            color: const Color.fromARGB(255, 243, 241, 241))),
                    style: TextButton.styleFrom(
                      backgroundColor: MyColors.mainC0lor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      onItemClick();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
