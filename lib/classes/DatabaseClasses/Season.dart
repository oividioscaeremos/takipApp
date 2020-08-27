import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<DocumentReference> episodes = new List<DocumentReference>();

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
        this.network});

  Season.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    rating = json['rating'];
    votes = json['votes'];
    episodeCount = json['episode_count'];
    airedEpisodes = json['aired_episodes'];
    title = json['title'];
    overview = json['overview'];
    firstAired = json['first_aired'];
    network = json['network'];
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
    data['episodes'] = this.episodes;

    return data;
  }
}