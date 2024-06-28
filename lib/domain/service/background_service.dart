import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';
import 'background_service_handler.dart' as serviceHandler;

abstract class BackgroundService {
  final Workmanager workmanager;
  final String taskIdentifier;

  BackgroundService(this.workmanager, this.taskIdentifier);

  /// Initializes the service
  Future<void> initialize() async {
    if (serviceHandler.activated) {
      return;
    }

    await this.workmanager.initialize(
      serviceHandler.backgroundServiceHandler,
      isInDebugMode: bool.parse(
          dotenv.maybeGet('DEBUG_BACKGROUND_SERVICE', fallback: 'false')!),
    );

    serviceHandler.activated = true;
  }

  /// Override to define start behavior
  Future<void> start();

  /// Cancels the service
  Future<void> cancel() {
    return this.workmanager.cancelByUniqueName(this.taskIdentifier);
  }

  /// Callback used as the main function for the service
  Future<bool> run(String taskName, Map<String, dynamic>? data);
}
