import 'package:fridayonline/service/hive_services.dart';

class HiveData {
  static String get platform => HiveServices.getData("platform") ?? "";
}
