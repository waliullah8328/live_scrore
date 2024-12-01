import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
   late GoogleMapController googleMapController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const  Text("Live Scores",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller){
          googleMapController = controller;


        },
          trafficEnabled: true,
        mapType: MapType.normal,
          onTap: (LatLng? latlng){
          print(latlng);

          },
          initialCameraPosition: CameraPosition(
        zoom: 16,
          target: LatLng(23.787524277982413, 90.37377321291159))),

    );
  }
  Color _indicatorColor(bool isMatchRunning){
    return isMatchRunning? Colors.red:Colors.yellow;

  }
}
