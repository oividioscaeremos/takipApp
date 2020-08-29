import 'Ids.dart';

class Episode {
  int season;
  int number;
  String title;
  Ids ids;
  int numberAbs;
  String overview;
  double rating;
  int votes;
  int commentCount;
  String firstAired;
  String updatedAt;
  List<String> availableTranslations;
  int runtime;

  Episode(
      {this.season,
        this.number,
        this.title,
        this.ids,
        this.numberAbs,
        this.overview,
        this.rating,
        this.votes,
        this.commentCount,
        this.firstAired,
        this.updatedAt,
        this.availableTranslations,
        this.runtime});

  Episode.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    number = json['number'];
    title = json['title'];
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    numberAbs = json['number_abs'];
    overview = json['overview'];
    rating = json['rating'];
    votes = json['votes'];
    commentCount = json['comment_count'];
    firstAired = json['first_aired'];
    updatedAt = json['updated_at'];
    availableTranslations = json['available_translations'].cast<String>();
    runtime = json['runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['season'] = this.season;
    data['number'] = this.number;
    data['title'] = this.title;
    if (this.ids != null) {
      data['ids'] = this.ids.toJson();
    }
    data['number_abs'] = this.numberAbs;
    data['overview'] = this.overview;
    data['rating'] = this.rating;
    data['votes'] = this.votes;
    data['comment_count'] = this.commentCount;
    data['first_aired'] = this.firstAired;
    data['updated_at'] = this.updatedAt;
    data['available_translations'] = this.availableTranslations;
    data['runtime'] = this.runtime;
    return data;
  }
}