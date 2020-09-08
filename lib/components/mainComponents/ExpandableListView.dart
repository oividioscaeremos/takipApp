import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class ExpandableListView extends StatefulWidget {
  final Season season;
  UserFull userFull;

  ExpandableListView({this.season, this.userFull});

  @override
  _ExpandableListView createState() => new _ExpandableListView();
}

class _ExpandableListView extends State<ExpandableListView> {
  _buildExpandableContent(Season season) {
    List<Widget> columnContent = [];

    for (var episode in season.episodes)
      columnContent.add(
        new ListTile(
          title: new Text(
            episode.title,
            style: new TextStyle(fontSize: 18.0),
          ),
          leading: new Icon(
            Icons.title,
          ),
          trailing: new Icon(
            Icons.check_box_outline_blank,
          ),
        ),
      );

    return columnContent;
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
            "${t.myShowsScreen.season} ${widget.season.number + 1}",
            style: TextStyle(
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
}
