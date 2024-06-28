import 'package:flexivity/domain/service/activity_background_service.dart';
import 'package:flexivity/domain/service/background_service.dart';
import 'package:workmanager/workmanager.dart';

bool activated = false;
Map<String, BackgroundService> services = {
  'SaveTodaysActivity': ActivityBackgroundService(workmanager: Workmanager()),
};

/// The callback dispatcher for the workmanager package
@pragma('vm:entry-point')
void backgroundServiceHandler() {
  Workmanager().executeTask((taskIdentifier, inputData) async {
    // Check if the service is defined
    final service = services[taskIdentifier];
    if (service == null) {
      return Future.error('No service found');
    }

    return service.run(taskIdentifier, inputData);
  });
}
