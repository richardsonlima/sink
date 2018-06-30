import 'package:flutter/material.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/ui/entry_list.dart';
import 'package:sink/ui/expense_form.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> entries = List();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          child: Text('Sink'),
          alignment: Alignment.center,
        ),
      ),
      body: EntryList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context, builder: (context) => AddExpenseScreen()),
      ),
    );
  }

  void handleUndo(Entry entry, int index) {
    final int entryIndex = entries.length >= index ? index : entries.length;

    setState(() {
      entries.insert(entryIndex, entry);
    });
  }
}