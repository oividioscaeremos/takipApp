import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Season.dart';

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
  List<Season> seasons = new List<Season>();

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
    title = json['title'] != null ? json['title'] : null;
    year = json['year'] != null ? json['year'] : null;
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    overview = json['overview'] != null ? json['overview'] : null;
    firstAired = json['first_aired'] != null ? json['first_aired'] : null;
    airs = json['airs'] != null ? new Airs.fromJson(json['airs']) : null;
    runtime = json['runtime'] != null ? json['runtime'] : null;
    certification =
        json['certification'] != null ? json['certification'] : null;
    network = json['network'] != null ? json['network'] : null;
    country = json['country'] != null ? json['country'] : null;
    trailer = json['trailer'] != null ? json['trailer'] : null;
    homepage = json['homepage'] != null ? json['homepage'] : null;
    status = json['status'] != null ? json['status'] : null;
    rating = json['rating'] != null ? json['rating'] : null;
    votes = json['votes'] != null ? json['votes'] : null;
    commentCount = json['comment_count'] != null ? json['comment_count'] : null;
    updatedAt = json['updated_at'] != null ? json['updated_at'] : null;
    language = json['language'] != null ? json['language'] : null;
    availableTranslations = json['available_translations'] != null
        ? json['available_translations'].cast<String>()
        : null;
    genres = json['genres'] != null ? json['genres'].cast<String>() : null;
    airedEpisodes =
        json['aired_episodes'] != null ? json['aired_episodes'] : null;
    if (json['seasons'] != null) {
      seasons = new List<Season>();
      json['seasons'].forEach((v) {
        seasons.add(new Season.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title.isNotEmpty ? this.title : null;
    data['year'] = this.year == null ? this.year : null;
    if (this.ids != null) {
      data['ids'] = this.ids.toJson();
    }
    data['overview'] = this.overview.isNotEmpty ? this.overview : null;
    data['first_aired'] = this.firstAired.isNotEmpty ? this.firstAired : null;
    if (this.airs != null) {
      data['airs'] = this.airs.toJson();
    }
    data['runtime'] = this.runtime == null ? this.runtime : null;
    data['certification'] =
        this.certification.isNotEmpty ? this.certification : null;
    data['network'] = this.network.isNotEmpty ? this.network : null;
    data['country'] = this.country.isNotEmpty ? this.country : null;
    data['trailer'] = this.trailer.isNotEmpty ? this.trailer : null;
    data['homepage'] = this.homepage.isNotEmpty ? this.title : null;
    data['status'] = this.status.isNotEmpty ? this.status : null;
    data['rating'] = this.rating == null ? this.rating : null;
    data['votes'] = this.votes == null ? this.votes : null;
    data['comment_count'] =
        this.commentCount == null ? this.commentCount : null;
    data['updated_at'] = this.updatedAt.isNotEmpty ? this.updatedAt : null;
    data['language'] = this.language.isNotEmpty ? this.language : null;
    data['available_translations'] = this.availableTranslations.isNotEmpty
        ? this.availableTranslations
        : null;
    data['genres'] = this.genres.isNotEmpty ? this.genres : null;
    data['aired_episodes'] =
        this.airedEpisodes == null ? this.airedEpisodes : null;
    if (this.seasons != null) {
      data['seasons'] = this.seasons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
