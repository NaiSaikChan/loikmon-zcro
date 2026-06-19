import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/providers/SubscriptionModel.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../widgets/MarqueeWidget.dart';

class BooksTile extends StatefulWidget {
  final Books? books;
  final bool? isdownloads;
  final int index;

  // ⚠️ First arg is POSITIONAL (matches callers: BooksTile(false, index:..., books:...))
  const BooksTile(
    this.isdownloads, {
    Key? key,
    required this.books,
    required this.index,
  })  : assert(books != null),
        super(key: key);

  @override
  State<BooksTile> createState() => _BooksTileState();
}

class _BooksTileState extends State<BooksTile> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppStateManager appStateNotifier = Provider.of<AppStateManager>(context);
    bool ispurchased =
        appStateNotifier.isBookPurchased(widget.books!.id!);
    SubscriptionModel subscriptionModel =
        Provider.of<SubscriptionModel>(context);

    // Color tokens based on current theme
    final cardColor =
        isDark ? MyColors.cardDark : MyColors.cardLight;
    final borderColor =
        isDark ? MyColors.borderDark : MyColors.borderLight;
    final textPrimary =
        isDark ? MyColors.textPrimaryDark : MyColors.textPrimaryLight;
    final textSecondary =
        isDark ? MyColors.textSecondaryDark : MyColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
            context,
            EbooksViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items:    widget.books,
              check:    widget.isdownloads,
            ),
          );
        },
        child: Container(
          width:  160,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color:        cardColor,
            borderRadius: BorderRadius.circular(16),
            border:       Border.all(color: borderColor, width: 1),
            // Subtle ambient shadow
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(isDark ? 0.30 : 0.06),
                blurRadius: 16,
                offset:     const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── Cover image ─────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft:     Radius.circular(15),
                      topRight:    Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.books!.thumbnail!,
                      height:   260,
                      width:    double.infinity,
                      fit:      BoxFit.cover,
                      imageBuilder: (_, imageProvider) => Container(
                        height: 260,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit:   BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (_, __) => const SizedBox(
                        height: 260,
                        child:  Center(child: CupertinoActivityIndicator()),
                      ),
                      errorWidget: (_, __, ___) => const SizedBox(
                        height: 260,
                        child:  Center(
                            child: Icon(Icons.error_outline,
                                color: Colors.grey)),
                      ),
                    ),
                  ),
                  // Rank badge  — top-left
                  Positioned(
                    top:  10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color:        MyColors.accentGlow,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: MyColors.accent.withOpacity(0.5),
                            width: 1),
                      ),
                      child: Text(
                        '${widget.index}',
                        style: const TextStyle(
                          color:      MyColors.accentSoft,
                          fontWeight: FontWeight.w700,
                          fontSize:   12,
                        ),
                      ),
                    ),
                  ),
                  // Audio badge — top-right
                  if (widget.books!.hasAudio == true)
                    Positioned(
                      top:   10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:        Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LineAwesomeIcons.volume_up_solid,
                          color: Colors.white,
                          size:  14,
                        ),
                      ),
                    ),
                ],
              ),

              // ── Info section ─────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title (marquee)
                    MarqueeWidget(
                      child: Text(
                        widget.books!.title!,
                        style: TextStyle(
                          color:      textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize:   14,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Author
                    Text(
                      widget.books!.author!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:    textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating + price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Stars
                        RatingStars(
                          value: double.parse(
                              widget.books!.rating ?? '0'),
                          onValueChanged: (_) {},
                          starBuilder: (_, color) =>
                              Icon(Icons.star_rounded,
                                  color: color, size: 14),
                          starCount: 5,
                          starSize:  14,
                          starColor:     MyColors.coins,
                          starOffColor:  MyColors.borderLight,
                          starSpacing:   1,
                          valueLabelVisibility: false,
                          maxValue:      5,
                          animationDuration:
                              const Duration(milliseconds: 800),
                          valueLabelColor:
                              const Color(0xff9b9b9b),
                          valueLabelTextStyle: const TextStyle(
                              fontSize: 0, color: Colors.transparent),
                          valueLabelRadius:  0,
                          valueLabelPadding: EdgeInsets.zero,
                          valueLabelMargin:  EdgeInsets.zero,
                        ),
                        // Coins badge
                        _CoinsBadge(
                            amount: widget.books!.amount.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Price / coins badge ───────────────────────────────────────
class _CoinsBadge extends StatelessWidget {
  final String amount;
  const _CoinsBadge({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color:        MyColors.coins.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: MyColors.coins.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LineAwesomeIcons.coins_solid,
              color: MyColors.coins, size: 13),
          const SizedBox(width: 3),
          Text(
            amount,
            style: TextStyle(
              color:      MyColors.mainC0lor,
              fontWeight: FontWeight.w700,
              fontSize:   12,
            ),
          ),
        ],
      ),
    );
  }
}
