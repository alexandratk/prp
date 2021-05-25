import 'package:admin/components/notes-list.dart';
import 'package:admin/components/users-list.dart';
import 'package:admin/pages/users.dart';
import 'package:admin/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).highlightColor,
        appBar: AppBar(
          title: Text("Admin"),
          leading: Icon(Icons.admin_panel_settings),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: FlatButton.icon(
                onPressed: () {
                  setState(() => sectionIndex = 0);
                },
                color: Colors.white24,
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                label: Text("Users"),
                textColor: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 40),
              child: FlatButton.icon(
                onPressed: () {
                  setState(() => sectionIndex = 1);
                },
                color: Colors.white24,
                icon: Icon(
                  Icons.notes_outlined,
                  color: Colors.white,
                ),
                label: Text("Notes"),
                textColor: Colors.white,
              ),
            ),
            FlatButton.icon(
              onPressed: () {
                AuthService _authService = AuthService();
                _authService.logOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: SizedBox.shrink(),
            ),
          ],
        ),
        body: sectionIndex == 0 ? UsersList() : NotesList(),
      ),
    );
  }
}
