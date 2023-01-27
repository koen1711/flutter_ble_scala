import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  print("Starting callbackDispatcher");
  Workmanager().executeTask((task, inputData) {
    print("Workmanagera");

    int? totalExecutions;

    try {
      //add code execution
      totalExecutions = int.parse(inputData?['totalExecutions']!);
    } catch (err) {
      throw Exception(err);
    }

    return Future.value(true);
  });
}
