import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/journalentry_provider.dart';
import 'screens/journalentry_detail.dart';
import 'screens/journalentry_edit.dart';
import 'screens/journalentry_list.dart';

import 'screens/login.dart';

void main() {
  runApp(AppReconnect());
}

class AppReconnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => JournalEntryProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal,
          textTheme: GoogleFonts.workSansTextTheme(Theme.of(context).textTheme),
        ),
        initialRoute: '/ScrLogin',
        routes: {
          '/ScrLaunch': (context) => ScrLaunch(),
          '/ScrJournalEntryDetail': (context) => ScrJournalEntryDetail(),
          '/ScrCreateJournalEntry': (context) => ScrEditJournalEntry(),
          '/ScrEditJournalEntry': (context) => ScrEditJournalEntry(),
          '/ScrLogin': (context) => LoginView(),
        },
      ),
    );
  }
}
