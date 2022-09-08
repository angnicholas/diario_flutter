import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'journalentry_item.dart';
import '../providers/journalentry_provider.dart';

class JournalEntryListBuilder extends StatelessWidget {
  final bool showFavourites;

  const JournalEntryListBuilder(this.showFavourites, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journalentrysProvider = Provider.of<JournalEntryProvider>(context);
    final journalentrys = journalentrysProvider.journalentryitems;
    journalentrys.sort((a, b) => a.datecreated.compareTo(b.datecreated));

    return SliverList(
      delegate: SliverChildListDelegate(
        List<JournalEntryItem>.generate(
          journalentrys.length,
          (int i) {
            return JournalEntryItem(journalentrys[i].id);
          },
        ),
      ),
    );
  }
}
