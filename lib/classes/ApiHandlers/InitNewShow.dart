import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class InitNewShow{
  final String showTraktID;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  InitNewShow({@required this.showTraktID});

  Show newShow = new Show();
  List<Season> newSeasons = new List<Season>();
  List<Episode> newEpisodes = new List<Episode>();

  Future<Show> initShow() async {
    Firebase.initializeApp();
    DocumentSnapshot ds = await firestore.collection('shows').doc(this.showTraktID).get();

    if (ds.data() != null) {
        return Show.fromJson(ds.data());
    }

    QueryBuilder queryBuilder = QueryBuilder(
        show: this.showTraktID,
        isExtended: true
    );

    final String showResponse = await queryBuilder.getResponse();

    newShow = Show.fromJson(jsonDecode(showResponse));
    queryBuilder =
        QueryBuilder(show: this.showTraktID, season: "", isExtended: true);

    final String seasonsResponse = await queryBuilder.getResponse();
    var season = jsonDecode(seasonsResponse) as List;
    newSeasons = season.map((s) => Season.fromJson(s)).toList();
    for (int i = 0; i < newSeasons.length - 1; i++) {
      queryBuilder = QueryBuilder(show: this.showTraktID,
          season: (i + 1).toString(),
          episode: "",
          isExtended: true);
      final String episodesOfASeason = await queryBuilder.getResponse();
      var episodesOfTheSeason = jsonDecode(episodesOfASeason) as List;
      newEpisodes =
          episodesOfTheSeason.map((e) => Episode.fromJson(e)).toList();
      newSeasons[i].episodes = newEpisodes;
    }
    print('here');
    newShow.seasons = newSeasons;
    firestore.collection('shows').doc(newShow.ids.trakt.toString()).set(
        newShow.toJson());
    return newShow;
  }
}