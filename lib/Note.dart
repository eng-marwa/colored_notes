import 'package:flutter_day2_iti3/constants.dart';

class Note {
  int? id;
  String title='';
  String text='';
  String date='';
  int? color;
  Note(
      {this.id,
      required this.title,
      required this.text,
      required this.date,
      this.color});

  Map<String, dynamic> toMap() => {
        colId: id,
        colTitle: title,
        colText: text,
        colDate: date,
        colColor: color
      };

  //Named constructor
  Note.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    title = map[colTitle];
    text = map[colText];
    color = map[colColor];
    date = map[colDate];
  }
}
