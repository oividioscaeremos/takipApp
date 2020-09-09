import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/mainComponents/ExpandableListView.dart';
import 'package:dizi_takip/components/mainComponents/ShowDetailTapHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EpisodeShowBox extends StatefulWidget {
  Show show;
  UserFull userFull;
  String watchNext;
  Future<bool> Function(BuildContext, DismissDirection, Show) onDismissed;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  EpisodeShowBox(
      {@required this.show,
      @required this.watchNext,
      @required this.onDismissed,
      @required this.userFull});

  @override
  _EpisodeShowBoxState createState() => _EpisodeShowBoxState();
}

class _EpisodeShowBoxState extends State<EpisodeShowBox> {
  @override
  Widget build(BuildContext context) {
    var showWatchNext = "S";
    if (widget.watchNext == "FINISHED") {
      showWatchNext = "WATCHED ALL.";
    } else {
      if (widget.watchNext.split(" ")[1].length == 1) {
        showWatchNext += "0${widget.watchNext.split(" ")[1]}";
      } else {
        showWatchNext += widget.watchNext.split(" ")[1];
      }
      if (widget.watchNext.split(" ")[3].length == 1) {
        showWatchNext += "E0${widget.watchNext.split(" ")[3]}";
      } else {
        showWatchNext += "E${widget.watchNext.split(" ")[3]}";
      }
    }

    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth,
      height: 70,
      color: Palette().colorPrimary,
      child: Dismissible(
        key: Key(widget.show.ids.trakt.toString()),
        secondaryBackground: Container(
          color: Colors.red,
          child: Icon(Icons.delete),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: 0,
            right: 0,
          ),
          height: 80,
        ),
        background: Container(
          color: Colors.green,
          child: Icon(Icons.remove_red_eye),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: 0,
            right: 0,
          ),
          height: 80,
        ),
        confirmDismiss: (direction) async {
          return widget.onDismissed(context, direction, widget.show);
        },
        onDismissed: (direction) {
          /*setState(() {
            items.removeAt(index);
          });*/
          //widget.onDismissed(context, direction, widget.show);

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(" dismissed, direction : ${direction.toString()}"),
              duration: Duration(
                milliseconds: 600,
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
                context: context,
                expand: true,
                enableDrag: true,
                isDismissible: true,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) {
                  return DraggableScrollableSheet(
                    minChildSize: 0.0,
                    initialChildSize: 1.0,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        color: Palette().colorPrimary,
                        height: SizeConfig.screenHeight,
                        child: StreamBuilder(
                          stream: widget.firestore
                              .collection("users")
                              .doc(widget.userFull.username)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapsh) {
                            if (snapsh.hasData) {
                              UserFull newUserFull =
                                  UserFull.fromJson(snapsh.data.data());
                              print(
                                  "snapshot changed++++asd++++++++++++++++++++++++++++++++++++++++++++++++++");
                              return CustomScrollView(
                                slivers: [
                                  SliverPersistentHeader(
                                    floating: true,
                                    pinned: true,
                                    delegate: ShowDetailTapHeader(
                                      show: widget.show,
                                      maxExtent: 300.0,
                                      minExtent: 2.0,
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        Season _season =
                                            widget.show.seasons[index];

                                        return ExpandableListView(
                                          show: widget.show,
                                          season: _season,
                                          userFull: newUserFull,
                                        );
                                      },
                                      childCount:
                                          widget.show.seasons.length - 1,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      );
                    },
                  );
                });
          },
          child: Container(
            color: Palette().colorPrimary,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: 8,
              right: 8,
            ),
            height: 80,
            child: Center(
              child: Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.show.title.toUpperCase(),
                      style: TextStyle(
                        color: Palette().colorQuaternary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.watchNext == "FINISHED" ? "ENDED" : showWatchNext,
                      style: TextStyle(
                        color: Palette().colorQuaternary.withOpacity(.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                color: Palette().colorSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
