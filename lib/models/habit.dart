import 'package:isar/isar.dart';

//this line is needed to generate line
//then run: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  //habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  //completed days
  List<DateTime> completedDays = [];
}
