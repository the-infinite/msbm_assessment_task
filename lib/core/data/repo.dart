

import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  /// An empty data repository. Useful when trying to
  static const empty = DataRepository();

  /// A constructor that helps to instantiate data repositories.
  const DataRepository();

  /// The persistent storage available to this application so that locally
  /// stored data can be readily retrieved.
  SharedPreferences get localStorage => AppRegistry.find<SharedPreferences>();

  /// The network client set up for this data repository so that the user can
  /// retrieve data over the network.
  AppClient get client => AppRegistry.find<AppClient>();
}
