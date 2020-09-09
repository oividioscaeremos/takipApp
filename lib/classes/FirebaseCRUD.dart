import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/InternalQueries.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:flutter/cupertino.dart';

import 'DatabaseClasses/Season.dart';

class FirebaseCRUD {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UserFull _user;

  FirebaseCRUD.init({UserFull user}) {
    _user = user;
  }

  UserFull addShow({@required String showID}) {
    bool _isInOldList = false;
    if (_user.myOldShows.length != 0) {
      _user.myOldShows.forEach((key, value) {
        if (key == showID) {
          _isInOldList = true;
        }
      });
    }
    if (_isInOldList) {
      print("here motha");
      _fireStore.collection("users").doc(_user.username).update({
        "myOldShows.$showID": FieldValue.delete(),
        "myShows.$showID": _user.myOldShows[showID]
      });
      _user.myShows.putIfAbsent(showID, () => _user.myOldShows[showID]);
      _user.myOldShows.remove(showID);
    } else {
      print("im right hre");
      InitNewShow(showTraktID: showID).initShow().then((value) {
        _fireStore.collection("users").doc(_user.username).update({
          "myShows.$showID": new List<String>(),
          "watchNext.$showID": "Season 1 Episode 1"
        });
        _user.myShows.putIfAbsent(showID, () => new List<String>(0));
      });
    }
    return _user;
  }

  UserFull removeShow({@required String showID}) {
    _fireStore.collection("users").doc(_user.username).update({
      "myShows.$showID": FieldValue.delete(),
      "myOldShows.$showID": _user.myShows[showID]
    });
    _user.myOldShows.putIfAbsent(showID, () => _user.myShows[showID]);
    _user.myShows.remove(showID);
    return _user;
  }

  UserFull markShowAsWatched({@required Show show, Episode episode}) {
    String _episodeNum = _user.watchNext[show.ids.trakt.toString()];
    Episode _episode;
    if (episode == null) {
      _episodeNum = _user.watchNext[show.ids.trakt.toString()];

      _episode = show.seasons[int.parse(_episodeNum.split(' ')[1]) - 1]
          .episodes[int.parse(_episodeNum.split(' ')[3]) - 1];
    } else {
      log("im here99");
      log("Season ${episode.season} Episode ${episode.number}");
      _episode = episode;
      _episodeNum = "Season ${episode.season} Episode ${episode.number}";
    }

    if (_episodeNum == "FINISHED") {
      return _user;
    }
    int runtime = show.seasons[int.parse(_episodeNum.split(' ')[1]) - 1]
        .episodes[int.parse(_episodeNum.split(' ')[3]) - 1].runtime;

    String nextEpisodeSTR =
        InternalQueries().getNextEpisode(show: show, nextSTR: _episodeNum);
    _fireStore.collection("users").doc(_user.username).update({
      "myShows.${show.ids.trakt}":
          FieldValue.arrayUnion([_episode.ids.trakt.toString()]),
      "watchNext.${show.ids.trakt.toString()}": nextEpisodeSTR,
      "totalWatchTimeInMinutes": FieldValue.increment(runtime)
    });
    _user.myShows[show.ids.trakt.toString()].add(_episode.ids.trakt.toString());
    _user.totalWatchTimeInMinutes += runtime;
    _user.watchNext[show.ids.trakt.toString()] = nextEpisodeSTR;

    return _user;
  }

  UserFull markEpisodeAsNotWatched(
      {@required Episode episode, @required Show show}) {
    String showID;
    Show _show = show;
    Episode _episode = episode;
    List<int> episodes = new List<int>();
    int _watchNextSeason = 1;
    int _watchNextEpisode = 1;

    log("{episode.ids.trakt.toString()]} => ${episode.ids.trakt.toString()}\n{_user.myShows} => ${_user.myShows}");
    log("before${_user.myShows[show.ids.trakt.toString()]}");
    _user.myShows[show.ids.trakt.toString()]
        .remove(episode.ids.trakt.toString());
    log("after${_user.myShows[show.ids.trakt.toString()]}");

    _user.myShows.forEach((key, value) {
      value.forEach((element) {
        episodes.add(int.parse(element.toString()));
      });
      if (value.contains(episode.ids.trakt)) {
        showID = key;
      }
    });

    for (int i = 0; i < _show.seasons.length; i++) {
      if (_show.seasons[i].episodes == null) {
        continue;
      }
      for (int j = 0; j < _show.seasons[i].episodes.length; j++) {
        Season s = _show.seasons[i];
        Episode epi = _show.seasons[i].episodes[j];
        log("episode ${_show.seasons[i].episodes[j].toJson().toString()}");
        if (episodes.contains(epi.ids.trakt)) {
          log("izledik biz bunu ${epi.season} and ${epi.number}");
          if (j + 1 == s.episodes.length) {
            _watchNextSeason = epi.season + 1;
            _watchNextEpisode = 1;
          } else {
            _watchNextSeason = epi.season;
            _watchNextEpisode = epi.number + 1;
          }
        }
      }
    }
    int runtime = episode.runtime;
    _fireStore.collection("users").doc(_user.username).update({
      "myShows.${show.ids.trakt}":
          FieldValue.arrayRemove([episode.ids.trakt.toString()]),
      "watchNext.${show.ids.trakt.toString()}":
          "Season $_watchNextSeason Episode $_watchNextEpisode",
      "totalWatchTimeInMinutes": FieldValue.increment(-runtime)
    });

    _user.totalWatchTimeInMinutes -= runtime;
    _user.watchNext[show.ids.trakt.toString()] =
        "Season $_watchNextSeason Episode $_watchNextEpisode";

    return _user;
  }
}
