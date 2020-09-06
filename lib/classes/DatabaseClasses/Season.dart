import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Ids.dart';

class Season {
  int number;
  Ids ids;
  double rating;
  int votes;
  int episodeCount;
  int airedEpisodes;
  String title;
  String overview;
  String firstAired;
  String network;
  List<Episode> episodes;

  Season(
      {this.number,
      this.ids,
      this.rating,
      this.votes,
      this.episodeCount,
      this.airedEpisodes,
      this.title,
      this.overview,
      this.firstAired,
      this.network,
      this.episodes});

  Season.fromJson(Map<String, dynamic> json) {
    number = json['number'] != null ? json['number'] : null;
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    rating = json['rating'] != null ? json['rating'] : null;
    votes = json['votes'] != null ? json['votes'] : null;
    episodeCount = json['episode_count'] != null ? json['episode_count'] : null;
    airedEpisodes =
        json['aired_episodes'] != null ? json['aired_episodes'] : null;
    title = json['title'] != null ? json['title'] : null;
    overview = json['overview'] != null ? json['overview'] : null;
    firstAired = json['first_aired'] != null ? json['first_aired'] : null;
    network = json['network'] != null ? json['network'] : null;
    if (json['episodes'] != null) {
      episodes = new List<Episode>();
      json['episodes'].forEach((v) {
        episodes.add(new Episode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    if (this.ids != null) {
      data['ids'] = this.ids.toJson();
    }
    data['rating'] = this.rating;
    data['votes'] = this.votes;
    data['episode_count'] = this.episodeCount;
    data['aired_episodes'] = this.airedEpisodes;
    data['title'] = this.title;
    data['overview'] = this.overview;
    data['first_aired'] = this.firstAired;
    data['network'] = this.network;
    if (this.episodes != null) {
      data['episodes'] = this.episodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
