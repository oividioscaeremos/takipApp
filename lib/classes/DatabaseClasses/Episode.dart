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
  String firstAired;
  String updatedAt;
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
      this.firstAired,
      this.updatedAt,
      this.runtime});

  Episode.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    number = json['number'];
    title = json['title'];
    ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    numberAbs = json['number_abs'];
    overview = json['overview'];
    votes = json['votes'];
    firstAired = json['first_aired'];
    updatedAt = json['updated_at'];
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
    data['first_aired'] = this.firstAired;
    data['updated_at'] = this.updatedAt;
    data['runtime'] = this.runtime;
    return data;
  }
}
