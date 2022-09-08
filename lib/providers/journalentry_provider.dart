import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/journalentry.dart';
import '../services/authinterceptor.dart';

class JournalEntryProvider with ChangeNotifier {
  List<JournalEntry> _journalentryitems = [
    JournalEntry(
      id: 0,
      title: '.',
      datecreated: DateTime.parse('2001-06-06'),
      content: '.',
    ),
  ];

  List<JournalEntry> get journalentryitems {
    return [..._journalentryitems];
  }

  JournalEntry findbyid(int id) {
    try {
      return _journalentryitems.firstWhere((evnt) => evnt.id == id);
    } catch (error) {
      return JournalEntry(
          id: 0, title: 'hi', datecreated: DateTime.now(), content: 'hi');
    }
  }

  Future<void> fetchAndSetJournalEntries() async {
    final url = Uri.parse('http://10.0.2.2:8000/journalentry/list/');
    try {
      sendRequestWithAuthNoBody(http.get, url, (response) {
        print(response.body);
        final extractedData = json.decode(response.body) as List<dynamic>;
        final List<JournalEntry> loadedJournalEntries = [];
        extractedData.forEach((element) {
          print(element);
          DateTime dt = DateTime.parse(element['date_created']);

          loadedJournalEntries.add(JournalEntry(
              id: element['id'],
              title: element['title'],
              content: element['text'],
              datecreated: dt));
        });
        _journalentryitems = loadedJournalEntries;
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
  }

  void addJournalEntry(JournalEntry newJournalEntry) {
    final url = Uri.parse('http://10.0.2.2:8000/journalentry/create/');

    sendRequestWithAuth(
        http.post,
        url,
        (value) => json.encode(
              {
                'title': newJournalEntry.title,
                'text': newJournalEntry.content,
                'patient': value.id,
              },
            ), (response) {
      final newEntry = newJournalEntry.copyWith(
        id: json.decode(response.body)['id'], //get user id frm the backend
      );
      fetchAndSetJournalEntries();
      notifyListeners();
    });
  }

  Future<void> editJournalEntry(int id, JournalEntry newJournalEntry) async {
    final url = Uri.parse('http://10.0.2.2:8000/journalentry/$id/update/');
    sendRequestWithAuth(
        http.patch,
        url,
        (value) => json.encode(
              {
                'title': newJournalEntry.title,
                'text': newJournalEntry.content,
                'patient': value.id,
              },
            ), (response) {
      fetchAndSetJournalEntries();
      notifyListeners();
    });
  }

  Future<void> removeJournalEntry(int id) async {
    final url = Uri.parse('http://10.0.2.2:8000/journalentry/$id/delete/');
    sendRequestWithAuthNoBody(http.delete, url, (response) {
      fetchAndSetJournalEntries();
      notifyListeners();
    });
  }

  void removeAllJournalEntry(int infoid) {
    _journalentryitems.removeWhere((inf) => inf.id == infoid);
    notifyListeners();
  }
}
