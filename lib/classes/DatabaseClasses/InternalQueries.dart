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
            log("$i and $j");
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
    int rounds = 0;
    if (userFull.myShows.length == 0) {
      rounds = 0;
    } else {
      log("rounds first $rounds and next shall be ${(userFull.myShows.length / 10).ceil()}");
      rounds = (userFull.myShows.length / 10).ceil();
    }
    List<Show> showListToReturn = new List<Show>();
    List<int> showIDs = new List<int>();

    userFull.myShows.forEach((key, value) {
      showIDs.add(int.parse(key));
    });

    for (int i = 0; i < rounds; i++) {
      int maxSupportedRange = i == rounds - 1 ? showIDs.length % 10 : 10;

      await _firestore
          .collection("shows")
          .where("ids.trakt",
              whereIn:
                  showIDs.getRange(i * 10, i * 10 + maxSupportedRange).toList())
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((queryDocSnapshot) {
          log("snapshot for number $i");
          showListToReturn.add(Show.fromJson(queryDocSnapshot.data()));
        });
      });
    }
    return showListToReturn;
  }
}
