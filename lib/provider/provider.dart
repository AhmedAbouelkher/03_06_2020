import 'package:flutter/widgets.dart';
import 'package:haftaa/authentication/auth.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/settings/settings.dart';
import 'package:haftaa/settings/settings_controller.dart';

class ProviderCustom extends InheritedWidget {
  //Auth auth ;
  final Future<Settings> settings=  SettingsController.getSettings();

  ProductBloc productBloc = ProductBloc();

  ProviderCustom({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  // static ProductBloc of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(Provider) as Provider).productBloc;
  // }


  static ProviderCustom of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProviderCustom) as ProviderCustom);
  }
}
