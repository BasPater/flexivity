import 'package:flexivity/data/models/activity.dart';
import 'package:flexivity/data/remote/health/abstract_health_api.dart';
import 'package:flexivity/domain/repositories/health/abstract_health_repository.dart';

class HealthRepository implements IHealthRepository {
  final IHealthApi api;

  const HealthRepository(this.api);

  @override
  Future<Activity?> getTodaysActivity() {
    return api.getTodaysHealthData();
  }
}
