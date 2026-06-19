import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Categories.dart';
import 'package:loikmon/models/Itms.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/screens/CategoriesViewScreen.dart';
import 'package:loikmon/utils/my_colors.dart';

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pushNamed(
            CategoriesViewScreen.routeName,
            arguments: ScreenArguements(
              items: Itms(categories.id, categories.title, 0),
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
              // ── Cover image ──────────────────────────────
              CachedNetworkImage(
                imageUrl: categories.thumbnailUrl!,
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
                    const Center(child: Icon(Icons.category, color: Colors.grey)),
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

              // ── Glass label ──────────────────────────────
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
                          // Category name
                          Text(
                            categories.title!,
                            textAlign: TextAlign.center,
                            maxLines:  2,
                            overflow:  TextOverflow.ellipsis,
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
                                categories.articlescount.toString(),
                              ),
                              _statChip(
                                Icons.menu_book_rounded,
                                categories.bookscount.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Accent top-right pip  ─────────────────────
              Positioned(
                top:   10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color:        MyColors.accentGlow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: MyColors.accent.withOpacity(0.5), width: 1),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      color:      MyColors.accentSoft,
                      fontSize:   10,
                      fontWeight: FontWeight.w700,
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
