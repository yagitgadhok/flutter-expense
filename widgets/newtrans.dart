import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Newtransaction extends StatefulWidget {
  final Function addtx;
  // String titleinput;
  // String amountinput;

  Newtransaction(this.addtx);

  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  final titlecontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  DateTime selecteddate;

  void submit() {
    if (amountcontroller.text.isEmpty) {
      return;
    }
    final entertitle = titlecontroller.text;
    final enteramount = double.parse(amountcontroller.text);
    if (entertitle.isEmpty || enteramount <= 0 || selecteddate == null) {
      return;
    }
    widget.addtx(
      entertitle,
      enteramount,
      selecteddate,
    );
    Navigator.of(context).pop();
  }

  void presentdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        selecteddate = pickeddate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'TITLE'),
                controller: titlecontroller,
                onSubmitted: (_) => submit(),
                // onChanged: (val) {
                //   titleinput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'AMOUNT'),
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submit(),
                // onChanged: (val) {
                //   amountinput = val;
                // },
              ),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(selecteddate == null
                          ? 'Picked date: ${DateFormat.yMd().format(DateTime.now())}'
                          : 'Picked date: ${DateFormat.yMd().format(selecteddate)}'),
                    ),
                    FlatButton(
                      textColor: Colors.deepPurple,
                      child: Text(
                        'Choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: presentdatepicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text(
                  'ADD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Opensans',
                  ),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
