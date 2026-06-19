import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loikmon/audio_player/BookAudioPlayerPage.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/providers/AudioPlayerModel.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:http/http.dart' as http;
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppPdfViewer extends StatefulWidget {
  const AppPdfViewer({Key? key, this.books}) : super(key: key);
  static const routeName = "/AppPdfViewer";
  final Books? books;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AppPdfViewer> {
  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isfullscreen = false;
  PdfViewerController controller = PdfViewerController();
  //PdfViewerController? controller;
  //rbool isloading = true;
  bool isloading = true;
  List<dynamic> _audiochapters = [];
  bool _loadingChapters = true;
  bool _hasAudio = false;

  @override
  void initState() {
    print(widget.books!.book);
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      _fetchBookChapters();
    });
  }

  Future<void> _fetchBookChapters() async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.GET_BOOK_CHAPTERS),
        body: jsonEncode({
          "data": {"book_id": widget.books!.id}
        }),
      );

      final res = jsonDecode(response.body);

      if (res["status"] == "success") {
        setState(() {
          _audiochapters = res["data"];
          _loadingChapters = false;
        });
      } else {
        setState(() {
          _loadingChapters = false;
        });
      }
    } catch (e) {
      print("Error loading chapters: $e");

      setState(() {
        _loadingChapters = false;
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.books!.title!,
          style: TextStyles.display1(context).copyWith(
              //fontFamily: 'style1',
              fontSize: 18),
        ),
        actions: [
          Visibility(
            visible: widget.books!.hasAudio!,
            child: IconButton(
              padding: EdgeInsets.only(right: 25, left: 20),
              onPressed: () {
                final model =
                    Provider.of<AudioPlayerModel>(context, listen: false);

                model.playBookAudio(
                  widget.books!,
                  _audiochapters,
                  0,
                  preserveCurrentIfSameBook: true,
                );

                Navigator.pushNamed(
                  context,
                  UnifiedAudioPlayerPage.routeName,
                );
              },
              icon: const Icon(Icons.audiotrack, size: 24),
            ),
          ),
          /*IconButton(
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  //if Orientation is portrait then set to landscape mode
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  setState(() {
                    isfullscreen = true;
                  });
                } else {
                  //if Orientation is landscape then set to portrait
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.portraitUp,
                  ]);

                  setState(() {
                    isfullscreen = false;
                  });
                }
              },
              icon: Icon(isfullscreen
                  ? Icons.fullscreen_exit_outlined
                  : Icons.fullscreen_outlined)),*/
        ],
      ),
      body: PdfViewer.uri(
        Uri.parse(widget.books!.book!),
        controller: controller,
        params: PdfViewerParams(
          minScale: 1,
          loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
            return Center(
              child: CircularProgressIndicator(
                // totalBytes may not be available on certain case
                value: totalBytes != null ? bytesDownloaded / totalBytes : null,
                backgroundColor: Colors.grey,
              ),
            );
          },
          pageOverlaysBuilder: (context, pageRect, page) {
            return [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(page.pageNumber.toString(),
                      style: TextStyles.display1(context)
                          .copyWith(color: Colors.red)))
            ];
          },
          viewerOverlayBuilder: (context, size, handleLinkTap) => [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              // Your code here:
              onDoubleTap: () {
                controller.zoomUp(loop: true);
              },
              // If you use GestureDetector on viewerOverlayBuilder, it breaks link-tap handling
              // and you should manually handle it using onTapUp callback
              onTapUp: (details) {
                handleLinkTap(details.localPosition);
              },
              // Make the GestureDetector covers all the viewer widget's area
              // but also make the event go through to the viewer.
              child: IgnorePointer(
                child: SizedBox(width: size.width, height: size.height),
              ),
            ),
          ],
        ),
      ),
      /*SfPdfViewer.network(
                  books!.book!,
                  key: _pdfViewerKey,
                  controller: controller,
                  pageSpacing: 0,
                  //initialZoomLevel: 2,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  scrollDirection: PdfScrollDirection.horizontal,
                  initialScrollOffset: Offset.infinite,
                  onDocumentLoaded: (d) {
                    Navigator.of(context).pop();
                  },
                  onDocumentLoadFailed: (d) {
                    print(d.error);
                    print(d.description);

                    Navigator.of(context).pop();
                  },
                
              ),*/
    );
  }
}
