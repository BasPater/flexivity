
class Prediction {
  final String date;
  final double score;
  Prediction({required this.date, required this.score});
  Map<String, dynamic> toJson() => {
    'date': date,
    'score': score,
  };

  Prediction.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        score = json['score'];

}