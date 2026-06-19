import 'package:flutter/material.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Reviews.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../providers/CommentsModel.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';

class CommentsItem extends StatefulWidget {
  final Reviews? object;
  final int? index;
  final BuildContext? context;

  const CommentsItem(
      {Key? key,
      @required this.index,
      @required this.object,
      @required this.context})
      : assert(index != null),
        assert(object != null),
        assert(context != null),
        super(key: key);

  @override
  _CommentsItemState createState() => _CommentsItemState();
}

class _CommentsItemState extends State<CommentsItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Userdata? userdata = Provider.of<AppStateManager>(context).userdata;
    CommentsModel commentsModel = Provider.of<CommentsModel>(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: MyColors.mainC0lor,
              child: Center(
                child: Text(
                  widget.object!.email!.substring(0, 1).toCapitalized(),
                  style: TextStyles.display1(context).copyWith(
                      color: const Color.fromARGB(255, 247, 245, 245)),
                ),
              ),
            ),
            Container(width: 10),
            Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.object!.email!
                                  .substring(
                                      0, widget.object!.email!.indexOf('@'))
                                  .toCapitalized(),
                              style: TextStyles.caption(context)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                          Text(
                            TimUtil.timeAgoSinceDate(widget.object!.date!),
                            style: TextStyles.caption(context)
                                .copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        LineAwesomeIcons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        widget.object!.rating!,
                        style: TextStyles.caption(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                        widget.object!.content! == ""
                            ? widget.object!.content!
                            : Utility.getBase64DecodedString(
                                widget.object!.content!),
                        //maxLines: 10,
                        textAlign: TextAlign.left,
                        style: TextStyles.subhead(context).copyWith(
                            //color: MyColors.grey_80,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(height: 8),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Container(width: 10),
                          Visibility(
                            visible: commentsModel.isUser(
                                    userdata, widget.object!.email!)
                                ? true
                                : false,
                            child: InkWell(
                              child: Icon(Icons.edit,
                                  color: Colors.lightBlue, size: 20.0),
                              onTap: () async {
                                final _dialog = RatingDialog(
                                  initialRating:
                                      double.parse(widget.object!.rating!),
                                  // your app's name?
                                  title: Text(
                                    'Edit your Rating',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  //  initialtext: widget.object!.content! == ""
                                  //    ? widget.object!.content!
                                  //     : Utility.getBase64DecodedString(
                                  //        widget.object!.content!),
                                  submitButtonText: 'Update',
                                  // commentHint: 'add a comment',

                                  onCancelled: () => print('cancelled'),
                                  onSubmitted: (response) {
                                    print(
                                        'rating: ${response.rating}, comment: ${response.comment}');
                                    commentsModel.editComment(
                                      context,
                                      response.comment,
                                      response.rating,
                                      widget.object!.id!,
                                      widget.index!,
                                    );
                                  },
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                      true, // set to false if you want to force a rating
                                  builder: (context) => _dialog,
                                );
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: commentsModel.isUser(
                                    userdata, widget.object!.email!)
                                ? true
                                : false,
                            child: InkWell(
                              child: Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 20.0),
                              onTap: () {
                                Provider.of<CommentsModel>(context,
                                        listen: false)
                                    .showDeleteCommentAlert(
                                        widget.object!.id!, widget.index!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCommentDialog extends StatefulWidget {
  final id, index;
  final Function? function;
  ReportCommentDialog({Key? key, this.id, this.index, this.function})
      : super(key: key);

  @override
  _ReportCommentDialogState createState() => _ReportCommentDialogState();
}

class _ReportCommentDialogState extends State<ReportCommentDialog> {
  List<String> reportOptions = [];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "",
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: Text(t.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(t.ok),
          onPressed: () {
            Navigator.of(context).pop();
            widget.function!(widget.id, widget.index, reportOptions[_selected]);
          },
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          title: Text(reportOptions[index]),
                          value: index,
                          groupValue: _selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = index;
                            });
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
