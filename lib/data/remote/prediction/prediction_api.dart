import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../models/errors/api_exception.dart';
import '../../models/prediction.dart';
import '../base/http_api.dart';
import 'abstract_prediction_api.dart';

class PredictionApi extends HttpApi implements IPredictionApi {
  PredictionApi(super.client, super.credentials);

  @override
  Future<List<Prediction>> getPrediction() async {
    try {
      Response response = await super.get(
        'api/v1/ai/prediction',
      );
      if (response.statusCode != HttpStatus.ok) {
        throw ApiException(
          'Error retrieving groups, status: ${response.statusCode}.',
        );
      }
      // Decode the response body
      var jsonResponse = jsonDecode(response.body);

      // Map each item in the JSON response to a GetGroupResponse object
      List<Prediction> predictions = (jsonResponse as List)
          .map((item) => Prediction.fromJson(item))
          .toList();

      return predictions;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> getGoal(int stepGoal) async{
    try {
      Response response = await super.post(
        'api/v1/ai/goal',
        body: {'stepGoal': stepGoal},
      );
      if (response.statusCode != HttpStatus.ok) {
        throw ApiException(
          'Error retrieving groups, status: ${response.statusCode}.',
        );
      }
      // Decode the response body
      return response.body;
    } catch (e) {
      return Future.error(e);
    }
  }
}
