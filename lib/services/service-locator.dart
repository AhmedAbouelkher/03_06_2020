import 'package:get_it/get_it.dart';
import 'package:haftaa/services/calls-and-messages-service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  try {
    locator.registerSingleton(CallsAndMessagesService());
  } catch (e) {}
}
