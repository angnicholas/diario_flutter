import 'package:flutter/material.dart';

//This is the class for 'Journal Entry'
class JournalEntry with ChangeNotifier {
  final int id;
  final String title;
  final DateTime datecreated;
  final String content;

  JournalEntry({
    required this.id,
    required this.title,
    required this.datecreated,
    required this.content,
  });

  JournalEntry copyWith({
    int? id,
    String? title,
    DateTime? datecreated,
    String? content,
  }) =>
      JournalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        datecreated: datecreated ?? this.datecreated,
        content: content ?? this.content,
      );

  @override
  String toString() => '$id, $title, $datecreated, $content';
}
