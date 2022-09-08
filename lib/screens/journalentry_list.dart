import 'package:app_rewrite_draft/models/journalentry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import '../widgets/journalentry_item.dart';
import '../providers/journalentry_provider.dart';

enum FilterOptions {
  favourites,
  friends,
  calender,
}

//This is the screen for 'ScrLaunch'
class ScrLaunch extends StatefulWidget {
  const ScrLaunch({Key? key}) : super(key: key);

  @override
  State<ScrLaunch> createState() => _ScrLaunch();
}

class _ScrLaunch extends State<ScrLaunch> {
  bool _showOnlyFavourites = false;
  bool _showFavouriteJournalEntrys = false;
  bool _showOtherJournalEntrys = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    //Make this only run when the component is initialised.
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<JournalEntryProvider>(context)
          .fetchAndSetJournalEntries()
          .then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var journalentrys = Provider.of<JournalEntryProvider>(context, listen: true)
        .journalentryitems;
    var count = journalentrys
        .where((context) =>
            context.datecreated.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))
        .toList();

    var todaysjournalentrys = count.map((x) => x.title).toList().join(', ');
    final journalentrysProvider = Provider.of<JournalEntryProvider>(context);

    final favouriteJournalEntrys = journalentrysProvider.journalentryitems;
    final nonFavouriteJournalEntrys = journalentrysProvider.journalentryitems;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Journal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage<JournalEntry>(
                items: Provider.of<JournalEntryProvider>(context, listen: false)
                    .journalentryitems,
                searchLabel: 'Search JournalEntry',
                suggestion: Center(
                  child: Text('Search for your journalentry by name'),
                ),
                failure: Center(
                  child: Text('No journalentry found that matches your input'),
                ),
                filter: (journalentry) => [
                  journalentry.title,
                  journalentry.id.toString(),
                ],
                builder: (journalentry) => ListTile(
                  title: Text(journalentry.title),
                  subtitle: Text(journalentry.id.toString()),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 20,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Journal Entries',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: JournalEntryList(journalentryList: favouriteJournalEntrys),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 20,
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65.0,
        width: 65.0,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/ScrCreateJournalEntry',
            );
          },
        ),
      ),
    );
  }
}

class JournalEntryList extends StatelessWidget {
  const JournalEntryList({
    Key? key,
    required this.journalentryList,
  }) : super(key: key);

  final List<JournalEntry> journalentryList;

  @override
  Widget build(BuildContext context) {
    journalentryList.sort((a, b) => a.datecreated.compareTo(b.datecreated));

    return SliverList(
      delegate: SliverChildListDelegate(
          List<JournalEntryItem>.generate(journalentryList.length, (int i) {
        return JournalEntryItem(journalentryList[i].id);
      })),
    );
  }
}
