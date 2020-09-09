import 'dart:developer';

import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/classes/FirebaseCRUD.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class ExpandableListView extends StatefulWidget {
  final Show show;
  final Season season;
  UserFull userFull;

  ExpandableListView({this.show, this.season, this.userFull});

  @override
  _ExpandableListView createState() => new _ExpandableListView();
}

class _ExpandableListView extends State<ExpandableListView> {
  bool isWatched;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isWatched = false;

    log("season = ${widget.season.number}");
  }

  _onTapRemoveEpisode(Episode epis) {
    // remove the episode
    print("tapped");
    FirebaseCRUD crud = FirebaseCRUD.init(user: widget.userFull);

    setState(() {
      widget.userFull =
          crud.markEpisodeAsNotWatched(episode: epis, show: widget.show);
      isWatched = !isWatched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 1,
      itemBuilder: (context, i) {
        return ExpansionTile(
          title: Text(
            "${t.myShowsScreen.season} ${widget.season.number}",
            style: TextStyle(
              color: Palette().colorQuaternary,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Column(
              children: _buildExpandableContent(widget.season),
            ),
          ],
        );
      },
    );
  }

  _buildExpandableContent(Season season) {
    List<Widget> columnContent = [];
    Episode _thisEpisode;
    for (var episode in season.episodes) {
      widget.userFull.myShows.values.forEach((val) {
        if (val.contains(episode.ids.trakt.toString())) {
          isWatched = true;
        }
      });
      columnContent.add(
        new ListTile(
          title: new Text(
            episode.title,
            style: new TextStyle(
              fontSize: 16.0,
              color: Palette().colorQuaternary.withOpacity(.8),
            ),
          ),
          leading: new Icon(
            Icons.live_tv,
            size: 25.0,
            color: Palette().colorQuaternary,
          ),
          trailing: isWatched
              ? InkWell(
                  onTap: () => _onTapRemoveEpisode(episode),
                  child: new Icon(
                    Icons.check_box,
                    color: Palette().colorQuaternary.withOpacity(.8),
                  ),
                )
              : InkWell(
                  onTap: () => FirebaseCRUD.init(user: widget.userFull)
                      .markShowAsWatched(show: widget.show, episode: episode),
                  child: new Icon(
                    Icons.check_box_outline_blank,
                    color: Palette().colorQuaternary.withOpacity(.6),
                  ),
                ),
        ),
      );
      isWatched = false;
    }

    return columnContent;
  }
}
