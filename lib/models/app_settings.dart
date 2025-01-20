import 'package:isar/isar.dart';

//this line is needed to generate line
//then run: dart run build_runner build
part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
