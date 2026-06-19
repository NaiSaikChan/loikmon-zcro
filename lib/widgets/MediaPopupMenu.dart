import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/BookmarksModel.dart';
import '../i18n/strings.g.dart';
import '../models/Books.dart';

enum MenuIndex { DOWNLOAD, DELETE, PLAYLIST, BOOKMARK, UNBOOKMARK, SHARE }

class MenuList {
  MenuList({
    this.index,
    this.title = '',
  });

  String title;
  MenuIndex? index;
}

class MediaPopupMenu extends StatelessWidget {
  MediaPopupMenu(this.media, {this.isDownloads});
  final Books? media;
  final isDownloads;

  @override
  Widget build(BuildContext context) {
    BookmarksModel bookmarksModel = Provider.of<BookmarksModel>(context);

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isBookBookmarked(media);
        List<MenuList> choices = [];

        /*if (isDownloads != null &&
            downloadsModel.isMediaInDownloads(media!.id)!.status ==
                DownloadTaskStatus.complete) {
          choices
              .add(new MenuList(title: t.deletemedia, index: MenuIndex.DELETE));
        }*/
        choices
            .add(new MenuList(title: t.addplaylist, index: MenuIndex.PLAYLIST));
        if (isBookmarked) {
          choices.add(
              new MenuList(title: t.unbookmark, index: MenuIndex.UNBOOKMARK));
        } else {
          choices
              .add(new MenuList(title: t.bookmark, index: MenuIndex.BOOKMARK));
        }
        choices.add(new MenuList(title: t.share, index: MenuIndex.SHARE));
        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm.title),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (dynamic value) {},
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[500],
      ),
    );
  }

  downloadFIle(BuildContext context, Books media) {}
}

class ShareFile {
  static share(Books media) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    await Share.share(
      t.sharefiletitle +
          media.title! +
          "\n" +
          t.sharefilebody +
          " http://play.google.com/store/apps/details?id=" +
          packageName,
      subject: t.sharefiletitle + media.title!,
    );
  }
}
