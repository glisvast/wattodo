import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wattodo/home.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<String> _todos = [];

  // Shared Preferences for Storing List
  var prefs;

  // Save List Key
  String listKey = "todolist";

  void initState() {
    super.initState();
    _initSharedPreferences();

    Future.delayed(const Duration(milliseconds: 1000), () {
      Route route = MaterialPageRoute(
          builder: (context) => HomePage(
                gotprefs: prefs,
                gottodos: _todos,
                gotlistkey: listKey,
              ));
      Navigator.pushReplacement(context, route);
    });
  }

  _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _todos = _getList() == null ? [] : _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        'wattodo',
        style: TextStyle(
          color: Colors.blueAccent,
          //fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }

  Future _saveList() async {
    await prefs.setStringList(listKey, _todos);
    print('Saved');
  }

  List<String> _getList() {
    var temp = prefs.getStringList(listKey);
    print('Got List');
    return temp;
  }
}
