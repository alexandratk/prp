import 'package:admin/pages/home.dart';
import 'package:admin/pages/landing.dart';
import 'package:admin/pages/users.dart';
import 'package:admin/services/auth.dart';
import 'package:admin/services/database.dart';
import 'package:admin/services/repositore_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  final firestoreInstance = FirebaseFirestore.instance;
  final users = <Users>[];
  var filterNickname = "All users";
  var filterNicknameInput = "";
  var filterOnlyMyUsers = false;
  var filterTitle = "title";
  var filterTitleController = TextEditingController();
  var filterLevel = "Any level";

  var filterText = "";
  var filterHeight = 0.0;

  var usersList;
  List<Users> filter() {
    setState(() {
      filterText = filterNickname;
      filterHeight = 0;
    });

    var list = users;
    return list;
  }

  List<Users> clearFilter() {
    setState(() {
      filterNickname = "All users";
      filterText = filterNickname;
      filterOnlyMyUsers = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeight = 0;
    });

    var list = users;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    usersList = FutureBuilder(
        future: AuthService().getUserData(filterNickname),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
            );
          }
          return Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: new ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return new Card(
                          elevation: 2.0,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Container(
                              child: ListTile(
                            title: new Text("nicname_user:  " +
                                document.data()!['nickname'] +
                                "        account_type_user:  " +
                                document.data()!['account_type'] +
                                "        id_user:  " +
                                document.id),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                          content: new Text("Delete user " +
                                              document.data()!['nickname'] +
                                              "?"),
                                          actions: <Widget>[
                                            ListTile(
                                                trailing: FlatButton(
                                                  child: Text('NO'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                leading: FlatButton(
                                                  child: Text('YES'),
                                                  onPressed: () {
                                                    setState(() {
                                                      AuthService()
                                                          .delete(document.id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                ))
                                          ],
                                        ));
                              },
                              icon: Icon(Icons.delete_forever_rounded),
                              color: Colors.red,
                            ),
                          )));
                    }).toList(),
                  )));
        });

    var filterInfo = Padding(
        padding: EdgeInsets.only(left: 51, right: 51),
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 7, right: 7, bottom: 10),
          color: Colors.white12,
          height: 40,
          child: RaisedButton(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.filter_list),
                Text(
                  filterText,
                  style: TextStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                filterHeight = (filterHeight == 0.0 ? 180.0 : 0.0);
              });
            },
          ),
        ));

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Padding(
        padding: EdgeInsets.only(top: 0, left: 50, right: 50),
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 50, right: 50),
            child: Column(
              children: [
                TextFormField(
                  controller: filterTitleController,
                  decoration: const InputDecoration(labelText: 'Nickname'),
                  onChanged: (String val) => filterNicknameInput = val,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          onPressed: () {
                            filterNickname = filterNicknameInput;
                            filter();
                          },
                          child: Text("Apply",
                              style: TextStyle(color: Colors.white)),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          onPressed: () {
                            clearFilter();
                          },
                          child: Text("Clear",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );

    return Column(
      children: <Widget>[
        filterInfo,
        filterForm,
        usersList,
      ],
    );
  }
}
