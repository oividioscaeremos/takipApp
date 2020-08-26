import 'Ids.dart';

class ExtendedEpisode {
  int _season;
  int _number;
  String _title;
  Ids _ids;
  int _numberAbs;
  String _overview;
  double _rating;
  int _votes;
  int _commentCount;
  String _firstAired;
  String _updatedAt;
  List<String> _availableTranslations;
  int _runtime;

  ExtendedEpisode({int season,
    int number,
    String title,
    Ids ids,
    int numberAbs,
    String overview,
    double rating,
    int votes,
    int commentCount,
    String firstAired,
    String updatedAt,
    List<String> availableTranslations,
    int runtime}) {
    this._season = season;
    this._number = number;
    this._title = title;
    this._ids = ids;
    this._numberAbs = numberAbs;
    this._overview = overview;
    this._rating = rating;
    this._votes = votes;
    this._commentCount = commentCount;
    this._firstAired = firstAired;
    this._updatedAt = updatedAt;
    this._availableTranslations = availableTranslations;
    this._runtime = runtime;
  }

  int get season => _season;

  set season(int season) => _season = season;

  int get number => _number;

  set number(int number) => _number = number;

  String get title => _title;

  set title(String title) => _title = title;

  Ids get ids => _ids;

  set ids(Ids ids) => _ids = ids;

  int get numberAbs => _numberAbs;

  set numberAbs(int numberAbs) => _numberAbs = numberAbs;

  String get overview => _overview;

  set overview(String overview) => _overview = overview;

  double get rating => _rating;

  set rating(double rating) => _rating = rating;

  int get votes => _votes;

  set votes(int votes) => _votes = votes;

  int get commentCount => _commentCount;

  set commentCount(int commentCount) => _commentCount = commentCount;

  String get firstAired => _firstAired;

  set firstAired(String firstAired) => _firstAired = firstAired;

  String get updatedAt => _updatedAt;

  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  List<String> get availableTranslations => _availableTranslations;

  set availableTranslations(List<String> availableTranslations) =>
      _availableTranslations = availableTranslations;

  int get runtime => _runtime;

  set runtime(int runtime) => _runtime = runtime;

  ExtendedEpisode.fromJson(Map<String, dynamic> json) {
    _season = json['season'];
    _number = json['number'];
    _title = json['title'];
    _ids = json['ids'] != null ? new Ids.fromJson(json['ids']) : null;
    _numberAbs = json['number_abs'];
    _overview = json['overview'];
    _rating = json['rating'];
    _votes = json['votes'];
    _commentCount = json['comment_count'];
    _firstAired = json['first_aired'];
    _updatedAt = json['updated_at'];
    _availableTranslations = json['available_translations'].cast<String>();
    _runtime = json['runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['season'] = this._season;
    data['number'] = this._number;
    data['title'] = this._title;
    if (this._ids != null) {
      data['ids'] = this._ids.toJson();
    }
    data['number_abs'] = this._numberAbs;
    data['overview'] = this._overview;
    data['rating'] = this._rating;
    data['votes'] = this._votes;
    data['comment_count'] = this._commentCount;
    data['first_aired'] = this._firstAired;
    data['updated_at'] = this._updatedAt;
    data['available_translations'] = this._availableTranslations;
    data['runtime'] = this._runtime;
    return data;
  }
}