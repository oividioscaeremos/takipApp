class Airs {
  String day;
  String time;
  String timezone;

  Airs({this.day, this.time, this.timezone});

  Airs.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    data['timezone'] = this.timezone;
    return data;
  }
}