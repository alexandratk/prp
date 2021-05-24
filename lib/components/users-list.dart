import 'package:admin/pages/users.dart';
import 'package:admin/services/database.dart';
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

  _UsersListState() {
    firestoreInstance.collection("users").snapshots().listen((result) {
      result.docs.forEach((result) {
        users.add(Users(
            uid: result.id,
            title: result.data()["title"],
            author: result.data()["author"],
            description: result.data()["description"],
            level: result.data()["level"]));
        print(result.data()["title"]);
      });
    });
  }

  final firestoreInstance = FirebaseFirestore.instance;
  final users = <Users>[];

  var filterOnlyMyUsers = false;
  var filterTitle = "title";
  var filterTitleController = TextEditingController();
  var filterLevel = "Any level";

  var filterText = "";
  var filterHeight = 0.0;

  var usersList;
  List<Users> filter() {
    setState(() {
      filterText = filterOnlyMyUsers ? 'My Workouts' : 'All workouts';
      filterText += '/' + filterLevel;
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeight = 0;
    });

    var list = users;
    return list;
  }

  List<Users> clearFilter() {
    setState(() {
      filterText = 'All workouts/Any Level';
      filterOnlyMyUsers = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeight = 0;
    });

    var list = users;
    return list;
  }

  usersListCreate() async {
    firestoreInstance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        users.add(Users(
            uid: result.id,
            title: result.data()["title"],
            author: result.data()["author"],
            description: result.data()["description"],
            level: result.data()["level"]));
      });
    });
    usersList = Expanded(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              child: ListTile(title: Text(users[i].title)),
            ),
          );
        },
        itemCount: users.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(users.length);
    firestoreInstance.collection("users").snapshots().listen((result) {
      result.docs.forEach((result) {
        users.add(Users(
            uid: result.id,
            title: result.data()["title"],
            author: result.data()["author"],
            description: result.data()["description"],
            level: result.data()["level"]));
        print(result.data()["title"]);
      });
    });
    print(users.length);
    print("////////////");
    usersList = Expanded(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              child: ListTile(title: Text(users[i].title)),
            ),
          );
        },
        itemCount: users.length,
      ),
    );
    /*  var filterInfo = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      height: 40,
      child: RaisedButton(
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
            filterHeight = (filterHeight == 0.0 ? 280.0 : 0.0);
          });
        },
      ),
    );

    var levelMenuItems = <String>[
      'Any Level',
      'Beginner',
      'Intermediate',
      'Advanced'
    ].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text('Only My Workouts'),
                  value: filterOnlyMyUsers,
                  onChanged: (bool val) =>
                      setState(() => filterOnlyMyUsers = val)),
              TextFormField(
                controller: filterTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String val) => setState(() => filterTitle = val),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: () {
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
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );*/

    return Column(
      children: <Widget>[
        /*  filterInfo,
        filterForm,*/
        usersList,
      ],
    );
  }
}