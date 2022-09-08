import 'package:app_rewrite_draft/models/journalentry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../providers/journalentry_provider.dart';

//This is the screen for 'ScrEditJournalEntry'
class ScrEditJournalEntry extends StatefulWidget {
  const ScrEditJournalEntry({Key? key}) : super(key: key);

  @override
  State<ScrEditJournalEntry> createState() => _ScrEditJournalEntry();
}

class _ScrEditJournalEntry extends State<ScrEditJournalEntry> {
  final _journalentryform = GlobalKey<FormState>();

  var _createdjournalentry = JournalEntry(
    id: 0,
    title: '',
    content: '',
    datecreated: DateTime.now(),
  );

  var _isInit = true;
  var _isCreateJournalEntry = true; //'CREATE' or 'EDIT' journalentry.

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context)!.settings.arguments;
      if (id != null) {
        final id_int = id as int;

        //This is an edit journalentry.
        _isCreateJournalEntry =
            false; //An 'edit' journalentry, not a 'create' journalentry.
        _createdjournalentry =
            Provider.of<JournalEntryProvider>(context, listen: false)
                .findbyid(id_int);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveJournalEntry() {
    final isValid = _journalentryform.currentState!.validate();
    if (!isValid) {
      return;
    }
    _journalentryform.currentState!.save();

    if (_isCreateJournalEntry) {
      Provider.of<JournalEntryProvider>(context, listen: false)
          .addJournalEntry(_createdjournalentry);
    } else {
      Provider.of<JournalEntryProvider>(context, listen: false)
          .editJournalEntry(_createdjournalentry.id, _createdjournalentry);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Title
      appBar: AppBar(
        title: _isCreateJournalEntry
            ? Text('Add an JournalEntry')
            : Text(_createdjournalentry.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveJournalEntry,
            icon: Icon(Icons.save),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _journalentryform,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Enter journalentry name
                TextFormField(
                  initialValue: _createdjournalentry.title,
                  decoration: InputDecoration(
                    icon: Icon(Icons.celebration),
                    labelText: 'Journal Entry Name',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a journal entry name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _createdjournalentry = _createdjournalentry.copyWith(
                      title: value as String,
                    );
                  },
                ),

                //Enter journalentry date
                DateTimePicker(
                  initialDate: _createdjournalentry.datecreated,
                  initialValue: _createdjournalentry.datecreated.toString(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.note),
                  dateLabelText: 'Journal Entry Date',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a journal entry date.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    final dateTimeToSave = DateTime.parse(value!);
                    _createdjournalentry = _createdjournalentry.copyWith(
                      datecreated: dateTimeToSave,
                    );
                  },
                ),

                //Enter journalentry description
                TextFormField(
                  maxLines: null,
                  initialValue: _createdjournalentry.content,
                  decoration: InputDecoration(
                    icon: Icon(Icons.sticky_note_2),
                    labelText: 'Journal Entry Description',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _createdjournalentry = _createdjournalentry.copyWith(
                      content: value as String,
                    );
                  },
                ),

                const Divider(
                  height: 50,
                  thickness: 1,
                  color: Colors.black,
                ),

                if (!_isCreateJournalEntry)
                  const Divider(
                    height: 50,
                    thickness: 1,
                    color: Colors.black,
                  ),

                //Delete button
                if (!_isCreateJournalEntry)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                      'Do you want to remove this journalentry?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<JournalEntryProvider>(
                                          context,
                                          listen: false,
                                        ).removeJournalEntry(
                                            _createdjournalentry.id);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          '/ScrLaunch',
                                          (_) => false,
                                        );
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Delete JournalEntry',
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
