
import 'package:get_it/get_it.dart';
import 'package:haftaa/services/calls-and-messages-service.dart';
import 'package:haftaa/services/dynamic_link_service.dart';
import 'package:haftaa/services/navigation_service.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => CallsAndMessagesService());

}