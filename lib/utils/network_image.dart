import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

class PNetworkImage extends StatelessWidget {
  final String? image;
  final BoxFit? fit;
  final double? width, height;
  const PNetworkImage(this.image, {Key? key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager = Provider.of<AppStateManager>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: CachedNetworkImage(
        imageUrl: image!,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
            color: appStateManager.isDarkModeOn
                ? MyColors.headerdark
                : Colors.white,
            child: Center(child: CupertinoActivityIndicator())),
        errorWidget: (context, url, error) => Center(
            child: Icon(
          Icons.error,
          color: Colors.grey,
        )),
      ),
    );
  }
}
