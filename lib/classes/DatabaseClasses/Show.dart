import 'package:cloud_firestore/cloud_firestore.dart';

import 'Airs.dart';
import 'Ids.dart';

class Show {
  String title;
  int year;
  Ids ids;
  String overview;
  String firstAired;
  Airs airs;
  int runtime;
  String certification;
  String network;
  String country;
  String trailer;
  String homepage;
  String status;
  double rating;
  int votes;
  int commentCount;
  String updatedAt;
  String language;
  List<String> availableTranslations;
  List<String> genres;
  int airedEpisodes;
  List<DocumentReference> seasons = new List<DocumentReference>();

  Show(
      {this.title,
        this.year,
        this.ids,
        this.overview,
        this.firstAired,
        this.airs,
        this.runtime,
        this.certification,
        this.network,
        this.country,
        this.trailer,
        this.homepage,
        this.status,
        this.rating,
        this.votes,
        this.commentCount,
        this.updatedAt,
        this.language,
        this.availableTranslations,
        this.genres,
        this.airedEpisodes});

  Show.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    year = json['year'];
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    overview = json['overview'];
    firstAired = json['first_aired'];
    airs = json['airs'] != null ? new Airs.fromJson(json['airs']) : null;
    runtime = json['runtime'];
    certification = json['certification'];
    network = json['network'];
    country = json['country'];
    trailer = json['trailer'];
    homepage = json['homepage'];
    status = json['status'];
    rating = json['rating'];
    votes = json['votes'];
    commentCount = json['comment_count'];
    updatedAt = json['updated_at'];
    language = json['language'];
    availableTranslations = json['available_translations'].cast<String>();
    genres = json['genres'].cast<String>();
    airedEpisodes = json['aired_episodes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['year'] = this.year;
    if (this.ids != null) {
      data['ids'] = this.ids.toJson();
    }
    data['overview'] = this.overview;
    data['first_aired'] = this.firstAired;
    if (this.airs != null) {
      data['airs'] = this.airs.toJson();
    }
    data['runtime'] = this.runtime;
    data['certification'] = this.certification;
    data['network'] = this.network;
    data['country'] = this.country;
    data['trailer'] = this.trailer;
    data['homepage'] = this.homepage;
    data['status'] = this.status;
    data['rating'] = this.rating;
    data['votes'] = this.votes;
    data['comment_count'] = this.commentCount;
    data['updated_at'] = this.updatedAt;
    data['language'] = this.language;
    data['available_translations'] = this.availableTranslations;
    data['genres'] = this.genres;
    data['aired_episodes'] = this.airedEpisodes;
    data['seasons'] = this.seasons;

    return data;
  }
}
