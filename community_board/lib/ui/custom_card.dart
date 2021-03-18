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
                          onPressed: () {}),
                      SizedBox(height: 19),
                      IconButton(
                          icon: Icon(FontAwesomeIcons.trashAlt , size: 15),
                          onPressed: () {})
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
