import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Authors.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';

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
    Future.delayed(Duration.zero, () {
      setState(() {
        isfollowing = widget.categories.isfollowing!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
            context,
            AuthorsListScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items:    widget.categories,
              check:    isfollowing,
            ),
          );
        },
        child: Container(
          width: 140,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? MyColors.borderDark : MyColors.borderLight,
              width: 1,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Cover image ───────────────────────────────
              CachedNetworkImage(
                imageUrl: widget.categories.thumbnail!,
                imageBuilder: (_, imageProvider) => DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit:   BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (_, __) =>
                    const Center(child: CupertinoActivityIndicator()),
                errorWidget: (_, __, ___) =>
                    const Center(child: Icon(Icons.person, color: Colors.grey)),
              ),

              // ── Gradient scrim ───────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin:  Alignment.bottomCenter,
                      end:    Alignment.topCenter,
                      stops:  [0, 0.55],
                      colors: [MyColors.glassBottom, MyColors.glassTop],
                    ),
                  ),
                ),
              ),

              // ── Glass name badge ─────────────────────────
              Positioned(
                bottom: 0,
                left:   0,
                right:  0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name
                          Text(
                            widget.categories.name!,
                            textAlign:  TextAlign.center,
                            maxLines:   2,
                            overflow:   TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize:   14,
                              height:     1.3,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Stats row
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              _statChip(
                                Icons.article_rounded,
                                widget.categories.articlescount
                                    .toString(),
                              ),
                              _statChip(
                                Icons.menu_book_rounded,
                                widget.categories.bookscount.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: Colors.white70),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(
            color:      Colors.white70,
            fontSize:   11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
