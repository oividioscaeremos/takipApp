import 'dart:convert';

import 'dart:developer';

import 'package:dizi_takip/classes/ExceptionHandler.dart';
import 'package:flutter/cupertino.dart';

class UserFull {
  List<String> favoriteGenres;
  int totalWatchTimeInMinutes;
  String email;
  Map<String, List<String>> myOldShows = new Map<String, List<String>>();
  Map<String, List<String>> myShows = new Map<String, List<String>>();
  Map<String, String> watchNext = new Map<String, String>();
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
    if (json['myOldShows'] != null) {
      (json['myOldShows'] as Map<String, dynamic>).forEach((key, value) {
        var watchedEpisodes = List<String>.from(value);
        myOldShows.putIfAbsent(key, () => watchedEpisodes);
      });
    }
    if (json['myShows'] != null) {
      (json['myShows'] as Map<String, dynamic>).forEach((key, value) {
        var watchedEpisodes = List<String>.from(value);
        myShows.putIfAbsent(key, () => watchedEpisodes);
      });
    }
    if (json['watchNext'] != null) {
      (json['watchNext'] as Map<String, dynamic>).forEach((key, value) {
        watchNext.putIfAbsent(key, () => value);
      });
    }
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favoriteGenres'] = this.favoriteGenres;
    data['totalWatchTimeInMinutes'] = this.totalWatchTimeInMinutes;
    data['email'] = this.email;
    if (this.myOldShows != null) {
      data['myOldShows'] = this.myOldShows.toString();
    }
    if (this.myShows != null) {
      data['myShows'] = this.myShows.toString();
    }
    if (this.watchNext != null) {
      data['watchNext'] = this.watchNext.toString();
    }
    data['username'] = this.username;
    return data;
  }
}
