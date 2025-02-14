//given a habit list of completion days
//is the habbit completed today

import 'package:my_app/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

// Prepare HeatMap datasets

Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      //normalize date to void time mismatch
      final normalizeDate = DateTime(date.year, date.month, date.day);

      //if the date already exists in the database , increment its count

      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        //else initialize it witha a count of 1
        dataset[normalizeDate] = 1;
      }
    }
  }

  return dataset;
}
