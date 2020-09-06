import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:flutter/material.dart';

class InternalQueries {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Show show;

  String getNextEpisode({@required Show show, @required String nextSTR}) {
    if (nextSTR == "FINISHED") {
      return "FINISHED";
    }

    String season = nextSTR.split(' ')[1];
    String episode = nextSTR.split(' ')[3];
    log("season: $season episode: $episode");

    for (int i = 0; i < show.seasons.length; i++) {
      for (int j = 0; j < show.seasons[i].episodes.length; j++) {
        if (show.seasons[i].episodes[j].season.toString() == season &&
            show.seasons[i].episodes[j].number.toString() == episode) {
          if (show.seasons[i].episodes.indexOf(show.seasons[i].episodes[j]) ==
              show.seasons[i].episodes.length - 1) {
            log("moi here=============================================================================");
            if (i + 1 == show.seasons.length - 1) {
              log("here>");
              return "FINISHED";
            } else {
              log("or here>");

              return "Season ${show.seasons[i + 1].episodes[0].season} Episode ${show.seasons[i + 1].episodes[0].number}";
            }
          } else {
            return "Season ${show.seasons[i].episodes[j + 1].season} Episode ${show.seasons[i].episodes[j + 1].number}";
          }
        }
      }
    }
  }

  Future<List<Show>> getWatchNextListForUser(
      {@required UserFull userFull}) async {
    List<Show> showListToReturn = new List<Show>();
    List<int> showIDs = new List<int>();

    if (userFull.myShows.length > 10) {
      for (int i = 0; i < userFull.myShows.keys.length; i++) {
        showIDs.add(int.parse(userFull.myShows.keys.toList()[i]));
      }
    } else {
      userFull.myShows.forEach((key, value) {
        showIDs.add(int.parse(key));
      });
    }

    log("what this is ${showIDs.toString()}");

    QuerySnapshot snapshot = await _firestore
        .collection("shows")
        .where("ids.trakt", whereIn: showIDs)
        .get();
    snapshot.docs.forEach((queryDocSnapshot) {
      showListToReturn.add(Show.fromJson(queryDocSnapshot.data()));
    });

    return showListToReturn;
  }
}
