import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/ArticleBookmarksModel.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../utils/TextStyles.dart';

class ItemTile extends StatelessWidget {
  final Articles object;
  final int index;
  final List<Articles> items;
  final int position;
  final bool isFree;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.items,
    required this.position,
    required this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final textPrimary =
        isDark ? MyColors.textPrimaryDark : MyColors.textPrimaryLight;
    final textSecondary =
        isDark ? MyColors.textSecondaryDark : MyColors.textSecondaryLight;
    final borderColor =
        isDark ? MyColors.borderDark : MyColors.borderLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                ArticleViewerScreen.routeName,
                arguments: ScreenArguements(
                  position:  position,
                  items:     object,
                  itemsList: items,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Thumbnail ───────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width:  72,
                      height: 72,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: object.thumbnail!,
                            fit:      BoxFit.cover,
                            imageBuilder: (_, imageProvider) => DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit:   BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (_, __) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (_, __, ___) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.grey)),
                          ),
                          // Audio badge overlay
                          if (object.streamUrl != '')
                            Positioned(
                              bottom: 4,
                              right:  4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  LineAwesomeIcons.volume_up_solid,
                                  color: Colors.white,
                                  size:  11,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ── Text block ──────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author + date row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                object.author!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:      textSecondary,
                                  fontSize:   11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              object.date!,
                              style: TextStyle(
                                color:    textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Title
                        Text(
                          object.title!,
                          maxLines:  2,
                          overflow:  TextOverflow.ellipsis,
                          style: TextStyle(
                            color:      textPrimary,
                            fontSize:   14,
                            fontWeight: FontWeight.w700,
                            height:     1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Category + actions row
                        Row(
                          children: [
                            // Category pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    MyColors.accent.withOpacity(0.10),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: MyColors.accent
                                      .withOpacity(0.25),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                object.category!.toUpperCase(),
                                style: const TextStyle(
                                  color:      MyColors.accent,
                                  fontSize:   10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Bookmark icon
                            Consumer<ArticleBookmarksModel>(
                              builder:
                                  (context, bookmarksModel, child) {
                                bool isBookmarked = bookmarksModel
                                    .isArticleBookMarked(object.id);
                                return InkWell(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  onTap: () {
                                    if (isBookmarked)
                                      bookmarksModel
                                          .unBookmarkArticle(
                                              object.id);
                                    else
                                      bookmarksModel
                                          .bookmarkArticle(object);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isBookmarked
                                          ? LineAwesomeIcons.heart_solid
                                          : LineAwesomeIcons.heart,
                                      color: isBookmarked
                                          ? Colors.red
                                          : textSecondary,
                                      size: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            // Share icon
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                Utility.sharearticle(context, object);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.share_rounded,
                                  color: MyColors.info,
                                  size:  18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Divider ──────────────────────────────────────
          Divider(
            height:    1,
            thickness: 1,
            color:     borderColor,
          ),
        ],
      ),
    );
  }
}
