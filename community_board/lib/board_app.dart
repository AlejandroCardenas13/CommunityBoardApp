import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
/*  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print('Connection Completed!!');
      setState(() {});
    }); How does this work?
  }*/

  var fireStoreDb = FirebaseFirestore.instance.collection("board").snapshots();
  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    super.initState();
    nameInputController = new TextEditingController();
    titleInputController = new TextEditingController();
    descriptionInputController = new TextEditingController();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.auto_fix_high),
      ),
      body: StreamBuilder(
        stream: fireStoreDb,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int index) {
                return Text(snapshot.data.docs[index]['description']);
              });
        },
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            elevation: 24.0,
            contentPadding: EdgeInsets.all(10),
            content: Column(
              children: [
                Text('Please fill out the form.'),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autocorrect: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                          labelText: 'Your Name*'),
                      controller: nameInputController,
                    )),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autocorrect: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                          labelText: 'Title*'),
                      controller: titleInputController,
                    )),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autocorrect: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                          labelText: 'Description*'),
                      controller: descriptionInputController,
                    )),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    nameInputController.clear();
                    titleInputController.clear();
                    descriptionInputController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (nameInputController.text.isNotEmpty &&
                        titleInputController.text.isNotEmpty &&
                        descriptionInputController.text.isNotEmpty) {
                      FirebaseFirestore.instance.collection('board').add({
                        //Esto es como si enviara un json
                        "name": nameInputController.text,
                        "title": titleInputController.text,
                        "description": descriptionInputController.text,
                        "timeStamp": new DateTime.now()
                      }).then((response) {
                        print(response.id);
                        Navigator.pop(context);
                        nameInputController.clear();
                        titleInputController.clear();
                        descriptionInputController.clear();
                      });
                    }
                  },
                  child: Text('Save'))
            ],
          );
        });
  }
}
