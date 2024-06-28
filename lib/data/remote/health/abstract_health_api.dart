import 'package:flexivity/data/models/activity.dart';

abstract interface class IHealthApi {
  Future<Activity?> getTodaysHealthData();
}
