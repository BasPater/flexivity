import 'package:flexivity/domain/service/background_service.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

abstract class HourlyBackgroundService extends BackgroundService {
  final String taskName;
  HourlyBackgroundService(super.workmanager, super.taskIdentifier, this.taskName);

  /// Starts the background service
  @mustCallSuper
  @override
  Future<void> start() async {
    // Initialize the background service framework
    this.initialize();

    // Cancel the previous tasks
    this.cancel();

    // Register the task
    await this.workmanager.registerPeriodicTask(
      super.taskIdentifier,
      this.taskName,
      frequency: Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
