import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.docs[index];
    var docId = snapshot.docs[index].id;

    TextEditingController nameInputController =
        TextEditingController(text: snapshotData['name']);
    TextEditingController titleInputController =
        TextEditingController(text: snapshotData['title']);
    TextEditingController descriptionInputController =
        TextEditingController(text: snapshotData['description']);

    var timeToDate = new DateTime.fromMillisecondsSinceEpoch(
        snapshotData["timeStamp"].seconds * 1000);
    var dateFormatted = formatDate(timeToDate, [DD, '\\, ', M, ' ', yy]);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 180,
          child: Card(
            elevation: 9,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshotData['title']),
                  subtitle: Text(snapshotData['description']),
                  leading: CircleAvatar(
                    radius: 34,
                    child: Text(snapshotData['title'].toString()[0]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("By. ${snapshotData['name']} "),
                    // Text(!(dateFormatted.isNotEmpty) ? "NA" : dateFormatted),
                    Text(dateFormatted)
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(FontAwesomeIcons.edit, size: 15),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    elevation: 24.0,
                                    contentPadding: EdgeInsets.all(10),
                                    content: Column(
                                      children: [
                                        Text(
                                            'Please fill out the form to update.'),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              autocorrect: true,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  labelText: 'Your Name*'),
                                              controller: nameInputController,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              autocorrect: true,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  labelText: 'Title*'),
                                              controller: titleInputController,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              autocorrect: true,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  labelText: 'Description*'),
                                              controller:
                                                  descriptionInputController,
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
                                            if (nameInputController
                                                    .text.isNotEmpty &&
                                                titleInputController
                                                    .text.isNotEmpty &&
                                                descriptionInputController
                                                    .text.isNotEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection("board")
                                                  .doc(docId)
                                                  .update({
                                                //Esto es como si enviara un json
                                                "name":
                                                    nameInputController.text,
                                                "title":
                                                    titleInputController.text,
                                                "description":
                                                    descriptionInputController
                                                        .text,
                                                "timeStamp": new DateTime.now()
                                              }).then((response) {
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          child: Text('Update'))
                                    ],
                                  );
                                });
                          }),
                      SizedBox(height: 19),
                      IconButton(
                          icon: Icon(FontAwesomeIcons.trashAlt, size: 15),
                          onPressed: () async {
                            var collectionReference =
                                FirebaseFirestore.instance.collection("board");
                            await collectionReference.doc(docId).delete();
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
