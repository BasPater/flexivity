import 'package:flexivity/data/models/activity.dart';

abstract interface class IHealthRepository {
  Future<Activity?> getTodaysActivity();
}
