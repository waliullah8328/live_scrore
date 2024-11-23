import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_scrore/model/cricket_score_model.dart';


class LiveScore extends StatefulWidget {
  const LiveScore({super.key});

  @override
  State<LiveScore> createState() => _LiveScoreState();
}

class _LiveScoreState extends State<LiveScore> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<CricketScoreModel> _cricketScore = [];
  bool _inProgress = false;

  Future<void> _getScoreData()async{
    _inProgress = true;
    setState(() {});
    _cricketScore.clear();
    final QuerySnapshot snapshot = await _firebaseFirestore.collection('cricket').get();
    for(DocumentSnapshot doc in snapshot.docs){
      _cricketScore.add(CricketScoreModel.fromJson(doc.id ,doc.data() as Map<String,dynamic>));
    }
    _inProgress = false;
    setState(() {});

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getScoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const  Text("Live Scores",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Visibility(
        replacement: const Center(child: CircularProgressIndicator(),),
        visible: _inProgress == false,
        child: ListView.builder(
          itemCount: _cricketScore.length,
          physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
            final cricketScore = _cricketScore[index];
              return ListTile(

                leading: CircleAvatar(
                  backgroundColor: _indicatorColor(cricketScore.isMatchRunning),
                  radius: 8,
                ),
                title: Text(cricketScore.matchId),
                subtitle: Text("Team 1: ${cricketScore.teamOneName} \n Team 2: ${cricketScore.teamTwoName}"),
                trailing: Text("${cricketScore.teamOneScore}/ ${cricketScore.teamTwoScore}"),

              );
            },
        ),
      ),

    );
  }
  Color _indicatorColor(bool isMatchRunning){
    return isMatchRunning? Colors.green:Colors.grey;

  }
}
