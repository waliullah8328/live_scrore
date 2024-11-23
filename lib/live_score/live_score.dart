import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  void extractData(QuerySnapshot<Map<String,dynamic>>? snapshot){
    _cricketScore.clear();
    for(DocumentSnapshot doc in snapshot?.docs?? []){
      _cricketScore.add(CricketScoreModel.fromJson(doc.id ,doc.data() as Map<String,dynamic>));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const  Text("Live Scores",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [

          // Manual featch Data and show the data
      /*
          Visibility(
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
            ),*/



          //const SizedBox(height: 60,),
           SizedBox(
             height: 400,
             child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("cricket").snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.hasData){
                    extractData(snapshot.data);
                    return ListView.builder(
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
                          subtitle: Text("Team 1: ${cricketScore.teamOneName} \n Team 2: ${cricketScore.teamTwoName}\n Winner Team: ${cricketScore.winnerTeam}"),
                          trailing: Text("${cricketScore.teamOneScore}/ ${cricketScore.teamTwoScore}"),

                        );
                      },
                    );

                  }
                  return const SizedBox();

                }
              ),
           ),



        ],
      ),

    );
  }
  Color _indicatorColor(bool isMatchRunning){
    return isMatchRunning? Colors.red:Colors.yellow;

  }
}
