import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/journalentry_provider.dart';
import '../widgets/detail_row.dart';

class ScrJournalEntryDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = //'id' of 'JournalEntry'
        ModalRoute.of(context)!.settings.arguments as int;
    final loadedJournalEntry =
        Provider.of<JournalEntryProvider>(context).findbyid(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedJournalEntry.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/ScrEditJournalEntry',
                  arguments: id,
                );
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          children: [
            //JournalEntry name
            DetailRow(
              displayicon: Icon(Icons.celebration),
              labeltext: '  JournalEntry: ',
              contenttext: loadedJournalEntry.title,
            ),

            //JournalEntry date
            DetailRow(
              displayicon: Icon(Icons.note),
              labeltext: '  Date: ',
              contenttext: DateFormat.yMMMMd('en_US')
                  .format(loadedJournalEntry.datecreated),
            ),

            //JournalEntry description
            if (loadedJournalEntry.content != null) ...[
              DetailRow(
                displayicon: Icon(Icons.sticky_note_2),
                labeltext: '  Description: ',
                contenttext: loadedJournalEntry.content,
              )
            ],
          ],
        ),
      ),
    );
  }
}
