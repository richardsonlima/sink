import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';

//TODO: show in bar chart?
class YearExpenses extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  YearExpenses({@required this.to})
      : this.from = DateTime(to.year - 1, to.month + 1);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreRepository.snapshotBetween(from, to),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PaddedCircularProgressIndicator();
          }

          List<Entry> entries = snapshot.data.documents
              .where((ds) => ds['type'] != EntryType.INCOME.index)
              .map((ds) => Entry.fromSnapshot(ds))
              .toList();

          List<_MonthlyExpense> months = groupByMonth(entries);
          List<Widget> monthlyExpenditures = months
              .map((m) => Text("${monthsName(m.date)}: ${m.amount}"))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: monthlyExpenditures,
            ),
          );
        },
      ),
    );
  }

  List<_MonthlyExpense> groupByMonth(List<Entry> entries) {
    var grouped = Map<DateTime, double>();
    entries.forEach((entry) => grouped.update(
        DateTime(entry.date.year, entry.date.month),
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount));

    var months = grouped.entries
        .map((entry) => _MonthlyExpense(entry.key, entry.value))
        .toList()
          ..sort();

    return months.reversed.toList();
  }
}

class _MonthlyExpense implements Comparable<_MonthlyExpense> {
  DateTime date;
  double amount;

  _MonthlyExpense(this.date, this.amount);

  @override
  int compareTo(_MonthlyExpense other) {
    return this.date.compareTo(other.date);
  }

  @override
  String toString() {
    return '_MonthlyExpense{date: $date, amount: $amount}';
  }
}
