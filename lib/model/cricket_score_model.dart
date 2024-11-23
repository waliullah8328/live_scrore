class CricketScoreModel{
  final String teamOneName;
  final String matchId;
  final String teamTwoName;
  final String winnerTeam;
  final int teamOneScore;
  final int teamTwoScore;
  final bool isMatchRunning;

  CricketScoreModel( {required this.matchId, required this.teamOneName, required this.teamTwoName, required this.winnerTeam, required this.teamOneScore, required this.teamTwoScore, required this.isMatchRunning,});

  factory CricketScoreModel.fromJson(String id,Map<String,dynamic> json){
  return CricketScoreModel(
       matchId:id,
      teamOneName: json["teamOne"],
      teamTwoName: json["teamTwo"],
      winnerTeam: json["winnerTeam"],
      teamOneScore: json["teamOneScrore"],
      teamTwoScore: json["teamTwoScore"],
      isMatchRunning: json["isMatchRunning"]
  );
}


}