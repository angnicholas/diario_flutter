import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/journalentry.dart';
import '../providers/journalentry_provider.dart';

class JournalEntryItem extends StatelessWidget {
  final int id;

  JournalEntryItem(
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final journalentrysProvider = Provider.of<JournalEntryProvider>(context);
    final journalentry = journalentrysProvider.findbyid(id);

    //Swipe to dismiss journalentry
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //AlertDialog confirmation to dismiss journalentry
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove this journalentry?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<JournalEntryProvider>(
          context,
          listen: false,
        ).removeJournalEntry(id);
      },
      //Swipe to dismiss journalentry background icon
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),

      //JournalEntry ListTile
      child: ListTile(
        tileColor: Colors.grey[300],
        horizontalTitleGap: 5.0,
        leading: Icon(Icons.note),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //JournalEntry Details
            Expanded(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: Text(
                        journalentry.title,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        // journalentry.journalentrydate.toString(),
                        DateFormat.yMMMMd('en_US')
                            .format(journalentry.datecreated),
                        //'hi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/ScrJournalEntryDetail',
                    arguments: id,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
