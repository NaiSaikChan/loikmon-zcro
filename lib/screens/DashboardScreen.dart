import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/ScreenArguements.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/screens/ArticleViewerScreen.dart';
import 'package:loikmon/screens/ArticlesListView.dart';
import 'package:loikmon/screens/ArticlesScreen.dart';
import 'package:loikmon/screens/AuthorsListScreen.dart';
import 'package:loikmon/screens/AuthorsListView.dart';
import 'package:loikmon/screens/AuthorsScreen.dart';
import 'package:loikmon/screens/BooksListView.dart';
import 'package:loikmon/screens/CategoriesListView.dart';
import 'package:loikmon/screens/CategoriesScreen.dart';
import 'package:loikmon/screens/CollectionDetailsScreen.dart';
import 'package:loikmon/screens/CollectionsScreen.dart';
import 'package:loikmon/screens/EbooksViewerScreen.dart';
import 'package:loikmon/screens/LeagueListView.dart';
import 'package:loikmon/screens/LeaguesScreen.dart';
import 'package:loikmon/screens/OthersBooksScreen.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Toasts.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:loikmon/utils/network_image.dart';
import 'package:loikmon/utils/rounded_bordered_container.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/NoitemScreen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen();

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<DashboardScreen> {
  late DashboardModel dashboardModel;

  onRetryClick() {
    dashboardModel.loadItems();
  }

  @override
  void initState() {
    Provider.of<DashboardModel>(context, listen: false).fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = Provider.of<DashboardModel>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color sectionBg =
        isDark ? MyColors.surfaceDark : MyColors.surfaceLight;

    if (dashboardModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 320,
              height: 320,
              child: Lottie.asset('assets/lottie/animation7.json'),
            ),
          ],
        ),
      );
    } else if (dashboardModel.isError) {
      return NoitemScreen(
          title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    }

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return SizedBox(height: 55, child: Center(child: body));
        },
      ),
      controller: dashboardModel.refreshController,
      onRefresh: () => dashboardModel.fetchItems(),
      onLoading: null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Hero Carousel ──────────────────────────────────
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 420,
                  child: FlutterCarousel(
                    options: CarouselOptions(
                      height:              420,
                      showIndicator:       true,
                      enableInfiniteScroll: true,
                      enlargeCenterPage:   false,
                      viewportFraction:    1.0,
                      autoPlay:            true,
                      autoPlayInterval:    const Duration(seconds: 4),
                      slideIndicator:      CircularSlideIndicator(
                        slideIndicatorOptions: const SlideIndicatorOptions(
                          currentIndicatorColor: MyColors.accent,
                          indicatorBackgroundColor: Colors.white54,
                          indicatorRadius: 5,
                          itemSpacing:     14,
                        ),
                      ),
                    ),
                    items: dashboardModel.sliders!.map((slider) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await _handleSliderTap(context, slider);
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Cover image
                                PNetworkImage(
                                  slider.thumbnail,
                                  fit:    BoxFit.cover,
                                  height: double.infinity,
                                ),
                                // Gradient scrim at bottom
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin:  Alignment.bottomCenter,
                                        end:    Alignment.topCenter,
                                        stops:  [0, 0.45],
                                        colors: [
                                          Color(0xD9000000),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Authors ────────────────────────────────────────
            _sectionHeader(context, t.authors, () {
              Navigator.of(context).pushNamed(AuthorsScreen.routeName);
            }),
            AuthorsListView(dashboardModel.bookAuthors!),
            const SizedBox(height: 28),

            // ── Categories ─────────────────────────────────────
            _sectionHeader(context, t.categories, () {
              Navigator.of(context).pushNamed(CategoriesScreen.routeName);
            }),
            CategoriesListView(dashboardModel.categories!),
            const SizedBox(height: 28),

            // ── Leagues ────────────────────────────────────────
            _sectionHeader(context, t.leagues, () {
              Navigator.of(context).pushNamed(LeaguesScreen.routeName);
            }),
            LeagueListView(dashboardModel.leagues!),
            const SizedBox(height: 28),

            // ── New Articles ───────────────────────────────────
            _sectionHeader(context, t.newarticles, () {
              Navigator.of(context).pushNamed(
                ArticlesScreen.routeName,
                arguments: ScreenArguements(position: 0),
              );
            }),
            ArticlesListView(dashboardModel.newarticles!),
            const SizedBox(height: 28),

            // ── New Books ──────────────────────────────────────
            _sectionHeader(context, t.newbooks, () {
              Navigator.of(context).pushNamed(
                OthersBooksScreen.routeName,
                arguments: ScreenArguements(position: 0),
              );
            }),
            BooksListView(dashboardModel.newbooks!),
            const SizedBox(height: 28),

            // ── Popular Articles ───────────────────────────────
            _sectionHeader(context, t.populararticles, () {
              Navigator.of(context).pushNamed(
                ArticlesScreen.routeName,
                arguments: ScreenArguements(position: 1),
              );
            }),
            ArticlesListView(dashboardModel.populararticles!),
            const SizedBox(height: 28),

            // ── Popular Books ──────────────────────────────────
            _sectionHeader(context, t.popularbooks, () {
              Navigator.of(context).pushNamed(
                OthersBooksScreen.routeName,
                arguments: ScreenArguements(position: 2),
              );
            }),
            BooksListView(dashboardModel.popularbooks!),
            const SizedBox(height: 28),

            // ── Collections ────────────────────────────────────
            if (dashboardModel.collections != null &&
                dashboardModel.collections!.isNotEmpty) ...[
              _sectionHeader(context, t.collection, () {
                Navigator.of(context).pushNamed(CollectionsScreen.routeName);
              }),
              _CollectionsRow(collections: dashboardModel.collections!),
              const SizedBox(height: 28),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Section header widget ────────────────────────────────
  Widget _sectionHeader(
      BuildContext context, String title, VoidCallback onSeeAll) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Accent pip
          Container(
            width:  4,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color:        MyColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyles.display5(context).copyWith(
                fontSize:   17,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? MyColors.textPrimaryDark
                    : MyColors.textPrimaryLight,
              ),
            ),
          ),
          // "See all" text button
          GestureDetector(
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    t.viewall,
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w600,
                      color:      MyColors.accent,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size:  12,
                    color: MyColors.accent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Slider tap handler ────────────────────────────────────
  Future<void> _handleSliderTap(BuildContext context, slider) async {
    if (slider.type == "link" || slider.type == "messenger") {
      final uri = Uri.parse(slider.link ?? '');
      if (await canLaunchUrl(uri)) await launchUrl(uri);
      return;
    }
    if (slider.item == null) {
      Toasts.info(context, '', 'Cannot open this at the moment');
      return;
    }
    if (slider.type == "article") {
      final List<Articles> articles = [slider.item as Articles];
      Navigator.pushNamed(
        context,
        ArticleViewerScreen.routeName,
        arguments: ScreenArguements(
            position: 0, items: slider.item, check: false, itemsList: articles),
      );
    } else if (slider.type == "author") {
      Navigator.pushNamed(
        context,
        AuthorsListScreen.routeName,
        arguments:
            ScreenArguements(position: 0, items: slider.item, check: false),
      );
    } else {
      Navigator.pushNamed(
        context,
        EbooksViewerScreen.routeName,
        arguments:
            ScreenArguements(position: 0, items: slider.item, check: false),
      );
    }
  }
}

// ── Collections horizontal row (extracted for clarity) ──────
class _CollectionsRow extends StatelessWidget {
  final List collections;
  const _CollectionsRow({required this.collections});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection:   Axis.horizontal,
        padding:           const EdgeInsets.symmetric(horizontal: 24),
        itemCount:         collections.length,
        separatorBuilder:  (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = collections[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).pushNamed(
                CollectionDetailsScreen.routeName,
                arguments: ScreenArguements(position: item.id),
              );
            },
            child: SizedBox(
              width: 240,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: PNetworkImage(
                      item.coverImage,
                      fit:    BoxFit.cover,
                      height: 190,
                      width:  240,
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin:  Alignment.bottomCenter,
                            end:    Alignment.topCenter,
                            stops:  [0, 0.55],
                            colors: [
                              Color(0xCC000000),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text overlay
                  Positioned(
                    bottom: 14,
                    left:   14,
                    right:  14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:      Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize:   15,
                            height:     1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.bookCount ?? 0} books',
                          style: const TextStyle(
                            color:    Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
