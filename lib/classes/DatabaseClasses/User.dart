import 'dart:convert';

import 'dart:developer';

import 'package:dizi_takip/classes/ExceptionHandler.dart';
import 'package:flutter/cupertino.dart';

class UserFull {
  List<String> favoriteGenres;
  int totalWatchTimeInMinutes;
  String email;
  Map<String, List<String>> myShows = new Map<String, List<String>>();
  String username;

  UserFull(
      {this.favoriteGenres,
      this.totalWatchTimeInMinutes,
      this.email,
      this.myShows,
      this.username});

  UserFull.fromJson(Map<String, dynamic> json) {
    favoriteGenres = json['favoriteGenres'] != null
        ? json['favoriteGenres'].cast<String>()
        : null;
    totalWatchTimeInMinutes = json['totalWatchTimeInMinutes'];
    email = json['email'];
    if (json['myShows'] != null) {
      (json['myShows'] as Map<String, dynamic>).forEach((key, value) {
        var watchedEpisodes = List<String>.from(value);
        myShows.putIfAbsent(key, () => watchedEpisodes);
      });
    }
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favoriteGenres'] = this.favoriteGenres;
    data['totalWatchTimeInMinutes'] = this.totalWatchTimeInMinutes;
    data['email'] = this.email;
    if (this.myShows != null) {
      data['myShows'] = this.myShows.toString();
    }
    data['username'] = this.username;
    return data;
  }
}

class IndividualShow {
  List<int> individualShow;

  IndividualShow({this.individualShow});

  IndividualShow.fromJson(Map<String, dynamic> json) {
    log("json['myShows']hulo");
    log(json['myShows']);
    individualShow =
        json['myShows'] != null ? json['myShows'].cast<int>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.individualShow != null) {
      Map<String, dynamic> myShows = jsonDecode(data['myShows']);
      log("jsonEncode(myShows)");
      log(jsonEncode(myShows));
      //data['mahmut'] = this.individualShow;
    }
    return data;
  }
}
