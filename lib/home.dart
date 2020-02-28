import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.gotprefs, this.gottodos, this.gotlistkey})
      : super(key: key);

  var gotprefs;
  List<String> gottodos;
  var gotlistkey;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var _listcontroller = ScrollController();
  List<String> _todos;
  var _listlength;

  // AddSheet TextField Controller
  TextEditingController _textcontroller;

  // Shared Preferences for Storing List
  var prefs;

  // Save List Key
  String listKey;

  void initState() {
    super.initState();

    _todos = widget.gottodos;
    _listlength = _todos.length;
    prefs = widget.gotprefs;
    listKey = widget.gotlistkey;

    _textcontroller = TextEditingController();
  }

  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }

  updatepageState(value) {
    setState(() {
      _todos.add(value);
      _listlength = _todos.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'wattodo',
            style: TextStyle(
              color: Colors.blueAccent,
              //fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 2,
        backgroundColor: Colors.white,
        icon: Icon(Icons.add, size: 30, color: Colors.blueAccent),
        label: Text(
          'Add',
          style: TextStyle(color: Colors.blueAccent, fontSize: 19),
        ),
        onPressed: () {
          // Floating Action Button onPressed
          _onadding(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 10),
            child: Text('오늘 해야되는 거', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: _todolist(),
          ),
        ],
      ),
    );
  }

  Widget _todolist() {
    return ListView.builder(
      controller: _listcontroller,
      //shrinkWrap: true,
      itemCount: _listlength,
      itemBuilder: (context, index) {
        return Dismissible(
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
          key: Key(_todos[index]),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            _listlength = _todos.length - 1;
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(_todos[index] + ' dismissed')));
            setState(() {
              _todos.removeAt(index);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20),
                child: Text(_todos[index]),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  _onadding(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AddSheet(context);
      },
    );
  }

  AddSheet(context) {
    return Container(
      //Get Keyboard Height and adds it
      height: MediaQuery.of(context).viewInsets.bottom + 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 22, right: 20, left: 20),
            child: TextField(
              controller: _textcontroller,
              decoration: InputDecoration(
                labelText: 'New Todo',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
              ),
              onSubmitted: (String value) {
                _disposeaddsheet(context);
              },
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 15, right: 20, left: 20),
            child: FlatButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(13)),
              onPressed: () {
                _disposeaddsheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 38,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _disposeaddsheet(context) {
    print(_textcontroller.text);
    updatepageState(_textcontroller.text);
    _saveList();
    Navigator.pop(context);
    _textcontroller.clear();
  }

  Future _saveList() async {
    await prefs.setStringList(listKey, _todos);
    print('Saved');
  }
}
