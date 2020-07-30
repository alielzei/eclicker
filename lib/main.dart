import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Stories 1,2',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('logo')
        ),
        body: PollTileListView()
      )
    );
  }
}

class PollTileListView extends StatefulWidget {
  @override
  PollTileListViewState createState() => PollTileListViewState();
}

class PollTileListViewState extends State<PollTileListView> {
  
  List<DocumentSnapshot> pollDocumentSnapshotList;

  @override
  void initState() {
    super.initState();
    fetchNewPollTitles();
  }

  Future<void> fetchNewPollTitles(){
    const userId = 'QaPTrvLIWTa2cogzVKQB';
    // refreshing should only load new titles
    // scrolling down is another thing...
    // lookup pagination or something
    return Firestore.instance
      .collection('users/$userId/feed')
      .getDocuments()
      .then((pollsQuerySnapshot){
        setState((){
          pollDocumentSnapshotList = pollsQuerySnapshot.documents;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    print('i build');
    return pollDocumentSnapshotList == null 
    ? Center(child: CircularProgressIndicator())
    : RefreshIndicator(
      onRefresh: fetchNewPollTitles,
      child: ListView(
        children: 
        pollDocumentSnapshotList
          .map(_buildTile)
          .toList()
      ),
    );
  }

  Widget _buildTile(DocumentSnapshot pollDocumentSnapshot){
    return Column(
      children: <Widget>[

        // 1
        InkWell(
          onTap: (){
            print(pollDocumentSnapshot.documentID);
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Text('${pollDocumentSnapshot.documentID}')
                  )
                );
              }
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAvatar(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle(pollDocumentSnapshot['title']),
                      _buildRoom(pollDocumentSnapshot['room-name']),
                    ],
                  ),
                )
              ],
            ),
          )
        ),

        // 2
        Divider(thickness: 1, height: 0),
      ],
    );
  }

  Widget _buildAvatar(){
    //Avatar
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(),
    );
  }
  
  // 2
  Widget _buildTitle(title){
    return Text('$title', 
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
      )
    );
  }

    Widget _buildRoom(room){
    //Room
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text('$room',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

}