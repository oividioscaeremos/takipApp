import 'Show.dart';

class SearchResult {
  String type;
  double score;
  Show show;

  SearchResult({this.type, this.score, this.show});

  SearchResult.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    score = double.parse(json['score'].toString());
    show = json['show'] != null ? new Show.fromJson(json['show']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['score'] = this.score;
    if (this.show != null) {
      data['show'] = this.show.toJson();
    }
    return data;
  }
}
