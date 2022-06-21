import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sql_tut/db_handler.dart';
import 'package:flutter_sql_tut/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? title;
  int? age;
  String? description;
  String? email;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  // Initialize the databse
  DBHelper? dbHelper;

  // Data will be added to this list
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "NOTES SQL",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your Notes",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFFFF9B42),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: false,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // Updating the note
                              updateNote(
                                id: snapshot.data![index].id!,
                              );
                            },
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              key: ValueKey<int>(snapshot.data![index].id!),
                              background: Container(
                                child: Icon(
                                  Icons.delete_forever,
                                ),
                                color: Colors.redAccent,
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  // again load the list after deleting a note
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      // color: Colors.amber,
                                      color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)],
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Card(
                                  shadowColor: Colors.transparent,
                                  child: ListTile(
                                    tileColor:
                                        Theme.of(context).backgroundColor,
                                    contentPadding: EdgeInsets.all(10),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].title
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.cyan,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].email
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        snapshot.data![index].description
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                    trailing: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                        color: Colors.amber,
                                      ),
                                      child: Text(
                                        snapshot.data![index].age.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  createNote() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                  onChanged: (value) {
                    age = int.parse(value);
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                InkWell(
                  onTap: () {
                    dbHelper!
                        .insert(NotesModel(
                            title: title!,
                            age: age!,
                            description: description!,
                            email: email!))
                        .then((value) {
                      print("Data inserted !");
                      setState(() {
                        notesList = dbHelper!.getNotesList();
                      });
                    }).onError((error, stackTrace) {
                      print(error.toString());
                    });

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: Colors.pink.shade100,
                    ),
                    child: Text("Add"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  updateNote({int? id}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                  onChanged: (value) {
                    age = int.parse(value);
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                InkWell(
                  onTap: () {
                    dbHelper!.update(NotesModel(
                        id: id,
                        title: title!,
                        age: age!,
                        description: description!,
                        email: email!));
                    setState(() {
                      notesList = dbHelper!.getNotesList();
                    });

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: Colors.pink.shade100,
                    ),
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
