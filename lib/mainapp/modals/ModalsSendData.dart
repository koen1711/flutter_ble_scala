import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../basemodules/sqlite/useSQL.dart';

final sqlHandler = SQLHandler();

class QuickCommands extends StatefulWidget {
  final Function(String) onDataSubmitted;

  QuickCommands({required this.onDataSubmitted});

  @override
  AQuickCommands createState() =>
      AQuickCommands(onDataSubmitted: onDataSubmitted);
}

class AQuickCommands extends State<QuickCommands> {
  AQuickCommands({required this.onDataSubmitted});

  final Function(String) onDataSubmitted;
  List<Map> _commands = [];
  List<DropdownMenuItem<dynamic>> _commandsDropDown = [
    DropdownMenuItem(
      child: Text("None"),
      value: "None",
    )
  ];
  List<TextEditingController> _textControllers = [];
  var _selectedCommand = null;
  // the ListView for the params
  List<Widget> _params = [];
  TextEditingController _textController = TextEditingController();

  Future<List<DropdownMenuItem<dynamic>>> _dropDownButtons() async {
    // get all the commands from the database
    try {
      await sqlHandler.openDB(
          "commands.db", 1, "CREATE TABLE main (key TEXT, value)");
    } catch (e) {
      // create the table main
      var db = await sqlHandler.openDB('commands.db', 1, '');
      await sqlHandler.execute(db, "CREATE TABLE main (key TEXT, value)");
      // check if the defualt commands are in the database

    }

    var db = await sqlHandler.openDB(
        "commands.db", 1, "CREATE TABLE main (key TEXT, value)");
    var inserted =
        await sqlHandler.query(db, "main", "key = 'defualtcommands'");
    if (inserted.length == 0) {
      await sqlHandler.insert(db, "main", {
        "key": "SETDIGPIN",
        "value": "SETDIGPIN,{Pin:{int}},{Value:{int:0-255}}"
      });
      await sqlHandler.insert(db, "main", {
        "key": "SETANAPIN",
        "value": "SETANAPIN,{Pin:{int}},{Value{int:0-255}}"
      });
      await sqlHandler.insert(db, "main", {
        "key": "DRIVE",
        "value": "DRIVE,{Direction:{0,1,2,3,4/Stop,A,D,W,S}}}"
      });
      await sqlHandler
          .insert(db, "main", {"key": "defualtcommands", "value": "true"});
    }
    // check if the key newuser exists in main.db
    var a = await db.rawQuery("SELECT * FROM main");

    List<DropdownMenuItem<dynamic>> list = _commandsDropDown;

    _selectedCommand = "None";

    // loop through the commands and make a dropdown button for each
    for (var i = 0; i < a.length; i++) {
      if (a[i]['key'].toString() == "defualtcommands") {
        continue;
      }
      list.add(DropdownMenuItem(
        child: Text(a[i]['key'].toString()),
        value: a[i]['key'].toString(),
      ));
    }

    // add all dropdown menu items to a dropdown button
    return list;
  }

  void _fixParams() async {
    // get the params from the database
    var db = await sqlHandler.openDB(
        "commands.db", 1, "CREATE TABLE main (key TEXT, value)");
    var a = await sqlHandler.query(db, "main", "key = '$_selectedCommand'");
    // split the params
    var params = a[0]['value'].toString().split(',');
    // remove the command
    params.removeAt(0);
    // remove the last }
    params[params.length - 1] = params[params.length - 1]
        .substring(0, params[params.length - 1].length - 1);
    // make a list of textfields
    List<Widget> list = [];
    for (var i = 0; i < params.length; i++) {
      // make textcontroller and add it to to the list
      var controller = TextEditingController();
      _textControllers.add(controller);
      // split the param into name and type
      var param = params[i].split(':');
      // go through the params and remove the { and }
      for (var i = 0; i < param.length; i++) {
        param[i] = param[i].replaceAll("{", "");
        param[i] = param[i].replaceAll("}", "");
      }

      // add the textfield
      list.add(CupertinoTextField(
        // only allow numbers
        // remove { and }

        keyboardType:
            param[1] == "int" ? TextInputType.number : TextInputType.text,
        placeholder: param[0],
        controller: controller,
        onChanged: (value) {
          if (param.length == 3) {
          // check if the value is a number
            if (param[1] == "int" && param[2] == "0-255") {
              if (int.parse(value) > 255) {
                controller.text = "255";
              } else if (int.parse(value) < 0) {
                controller.text = "0";
              }
            }
          }
          if (param[1] == "int") {
            if (int.parse(value) < 0) {
              controller.text = "0";
            }
          }
        },
      ));
    }

    // add the send button

    list.add(CupertinoButton(
      child: Text("Send"),
      onPressed: () {
        // get the command
        var command = _selectedCommand;
        // get the params
        var params = _textControllers;
        // make a string
        var string = "$command,";
        // loop through the params and add them to the string
        for (var i = 0; i < params.length; i++) {
          string += params[i].text;
          if (i != params.length - 1) {
            string += ",";
          }
        }
        // send the string
        onDataSubmitted(string);
      },
    ));

    // set the state
    setState(() {
      _params = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedCommand);
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          onDataSubmitted('back');
          return true;
        },
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context) => Builder(
              builder: (context) => CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    leading: Container(), middle: Text('Quick Commands')),
                child: SafeArea(
                    bottom: false,
                    child: ListView(children: [
                      CupertinoButton(
                        child: Text("Scan for commands"),
                        onPressed: () async {
                          var r = await _dropDownButtons();
                          setState(() {
                            _commandsDropDown = r;
                          });
                        },
                      ),
                      DropdownButton(
                          items: _commandsDropDown,
                          value: _selectedCommand == null
                              ? "None"
                              : _selectedCommand,
                          onChanged: (value) async {
                            setState(() {
                              _selectedCommand = value.toString();
                            });
                            _fixParams();
                          }),
                      // add the params
                      ..._params,
                    ])),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
