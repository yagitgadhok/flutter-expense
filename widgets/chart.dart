import 'dart:core';
import 'package:expense/widgets/chartbar.dart';
import 'package:intl/intl.dart';
import 'package:expense/models/trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenttransaction;

  Chart(this.recenttransaction);

  List<Map<String, Object>> get groupedtransaction {
    return List.generate(
      7,
      (index) {
        final weekday = DateTime.now().subtract(
          Duration(days: index),
        );
        double totalsum = 0;
        for (var i = 0; i < recenttransaction.length; i++) {
          if (recenttransaction[i].date.day == weekday.day &&
              recenttransaction[i].date.month == weekday.month &&
              recenttransaction[i].date.year == weekday.year) {
            totalsum += recenttransaction[i].amount;
          }
        }

        return {
          'day': DateFormat.E().format(weekday).substring(0, 1),
          'amount': totalsum,
        };
      },
    );
  }

  double get totalspending {
    return groupedtransaction.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.3,
      child: Card(
        elevation: 7,
        margin: EdgeInsets.all(25),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedtransaction.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: Chartbar(
                  data['day'],
                  data['amount'],
                  totalspending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalspending,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
