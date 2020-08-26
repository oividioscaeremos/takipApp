class Ids {
  int _trakt;
  int _tvdb;
  String _imdb;
  int _tmdb;
  int _tvrage;

  Ids({int trakt, int tvdb, String imdb, int tmdb, int tvrage}) {
    this._trakt = trakt;
    this._tvdb = tvdb;
    this._imdb = imdb;
    this._tmdb = tmdb;
    this._tvrage = tvrage;
  }

  int get trakt => _trakt;
  set trakt(int trakt) => _trakt = trakt;
  int get tvdb => _tvdb;
  set tvdb(int tvdb) => _tvdb = tvdb;
  String get imdb => _imdb;
  set imdb(String imdb) => _imdb = imdb;
  int get tmdb => _tmdb;
  set tmdb(int tmdb) => _tmdb = tmdb;
  int get tvrage => _tvrage;
  set tvrage(int tvrage) => _tvrage = tvrage;

  Ids.fromJson(Map<String, dynamic> json) {
    _trakt = json['trakt'];
    _tvdb = json['tvdb'];
    _imdb = json['imdb'];
    _tmdb = json['tmdb'];
    _tvrage = json['tvrage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trakt'] = this._trakt;
    data['tvdb'] = this._tvdb;
    data['imdb'] = this._imdb;
    data['tmdb'] = this._tmdb;
    data['tvrage'] = this._tvrage;
    return data;
  }
}