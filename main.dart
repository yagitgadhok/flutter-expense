import 'package:expense/widgets/chart.dart';
import 'package:expense/widgets/newtrans.dart';
import 'package:expense/widgets/trans_list.dart';
import './models/trans.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses',
      theme: ThemeData(
        //brightness: Brightness.dark,
        primaryIconTheme: IconThemeData.fallback().copyWith(
          color: Colors.teal,
        ),
        accentIconTheme: IconThemeData.fallback().copyWith(
          color: Colors.amber,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.indigo,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          color: Colors.teal,
        ),
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'OpenSans',
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.black45,
          ),
        ),
      ),
      home: Myhomepage(),
    );
  }
}

class Myhomepage extends StatefulWidget {
  @override
  _MyhomepageState createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  final List<Transaction> usertransaction = [
    // Transaction(
    //   id: 'T1',
    //   title: 'new',
    //   amount: 69,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'T2',
    //   title: 'another',
    //   amount: 51,
    //   date: DateTime.now(),
    // )
  ];
  bool showchart = false;
  List<Transaction> get recenttransaction {
    return usertransaction.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  String titleinput;
  String amountinput;
  void addnewtransaction(String txtitle, double txamount, DateTime chosendate) {
    final newtx = Transaction(
      title: txtitle,
      amount: txamount,
      date: chosendate,
      id: DateTime.now().toString(),
    );
    setState(() {
      usertransaction.add(newtx);
    });
  }

  void startaddnewtransactioin(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
        return GestureDetector(
          onTap: () {},
          child: Newtransaction(addnewtransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void deletetransaction(String id) {
    setState(
      () {
        usertransaction.removeWhere(
          (tx) {
            return tx.id == id;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final islandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 36, 36, 2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amber,
        ),
        //backgroundColor: Colors.teal,
        title: Text('Expenses'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              startaddnewtransactioin(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (islandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('chart'),
                Switch(
                  value: showchart,
                  onChanged: (val) {
                    setState(() {
                      showchart = val;
                    });
                  },
                ),
              ],
            ),
            if(!islandscape) Chart(recenttransaction),
            if(!islandscape) Transactionlist(usertransaction, deletetransaction),
            if(islandscape) showchart
                ? Chart(recenttransaction)
                : Transactionlist(usertransaction, deletetransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          startaddnewtransactioin(context);
        },
      ),
    );
  }
}
