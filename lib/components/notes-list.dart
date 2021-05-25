import 'package:admin/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesList extends StatefulWidget {
  NotesList({Key? key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  var notesList;
  final firestoreInstance = FirebaseFirestore.instance;
  var filterNickname = "All users";
  var filterNicknameInput = "";
  var filterOnlyMyUsers = false;
  var filterTitle = "title";
  var filterTitleController = TextEditingController();
  var filterLevel = "Any level";

  var filterText = "";
  var filterHeight = 0.0;
  filter() {
    setState(() {
      filterText = filterNickname;
      filterHeight = 0;
    });
  }

  clearFilter() {
    setState(() {
      filterNickname = "All users";
      filterText = filterNickname;
      filterOnlyMyUsers = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeight = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    notesList = StreamBuilder(
      stream: AuthService().getPublicNotes(filterNickname),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
          );
        } else if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(top: 0, left: 50, right: 50),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 100,
                      child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        "title:  " +
                                            snapshot.data!.docs[index]
                                                ["title"] +
                                            "   by nickname:  " +
                                            snapshot.data!.docs[index]
                                                ['user_nickname'],
                                        maxLines: 1,
                                        textAlign: TextAlign.left),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => new AlertDialog(
                                                  content: new Text(
                                                      "Delete notes " +
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['title'] +
                                                          "?"),
                                                  actions: <Widget>[
                                                    ListTile(
                                                        trailing: FlatButton(
                                                          child: Text('NO'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        leading: FlatButton(
                                                          child: Text('YES'),
                                                          onPressed: () {
                                                            setState(() {
                                                              AuthService()
                                                                  .deleteNotes(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id);
                                                              Navigator.of(
                                                                      context)
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
                                  ),
                                  ListTile(
                                      title: Text(
                                    '${snapshot.data!.docs[index]['description'].toString()}',
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                  )),
                                ],
                              ),
                            ],
                          )));
                }),
          );
        }
        return CircularProgressIndicator();
      },
    );

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
                filterHeight = (filterHeight == 0.0 ? 160.0 : 0.0);
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
            padding: EdgeInsets.only(top: 0, left: 50, right: 50),
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
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        filterInfo,
        filterForm,
        notesList,
      ],
    ));
  }
}
