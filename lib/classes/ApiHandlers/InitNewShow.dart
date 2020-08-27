import 'dart:convert';

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

  Future<bool> addAllEpisodes() async {
    Firebase.initializeApp();

    if(firestore.collection('shows').doc(this.showTraktID) != null){
      return false;
    }

    QueryBuilder queryBuilder = QueryBuilder(show: this.showTraktID, isExtended: true);
    final String showResponse = await queryBuilder.getResponse();
    newShow = Show.fromJson(jsonDecode(showResponse));
    queryBuilder = QueryBuilder(show: this.showTraktID, season: "", isExtended: true);
    final String seasonsResponse = await queryBuilder.getResponse();
    var season = jsonDecode(seasonsResponse) as List;
    newSeasons = season.map((s) => Season.fromJson(s)).toList();


    for(int i = 0; i < newSeasons.length - 1; i++){
      print(i.toString());
      queryBuilder = QueryBuilder(show: this.showTraktID, season: (i+1).toString(), episode: "", isExtended: true);
      final String episodesOfASeason = await queryBuilder.getResponse();
      print("repo");
      var episodesOfTheSeason = jsonDecode(episodesOfASeason) as List;
      newEpisodes = episodesOfTheSeason.map((e) => Episode.fromJson(e)).toList();
      newEpisodes.forEach((episode) {
        firestore.collection('episodes').doc(episode.ids.trakt.toString()).set(episode.toJson());
        DocumentReference episodeRef = FirebaseFirestore.instance.collection('episodes').doc(episode.ids.trakt.toString());
        newSeasons[i].episodes.insert(newSeasons[i].episodes.length, episodeRef);
      });
    }

    newSeasons.forEach((s) {
      firestore.collection('seasons').doc(s.ids.trakt.toString()).set(s.toJson());
      DocumentReference seasonRef = FirebaseFirestore.instance.collection('seasons').doc(s.ids.trakt.toString());
      newShow.seasons.add(seasonRef);
    });
    firestore.collection('shows').doc(newShow.ids.trakt.toString()).set(newShow.toJson());
    return true;
  }
}