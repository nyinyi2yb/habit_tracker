import 'package:flutter/material.dart';
import 'package:my_app/components/my_drawer.dart';
import 'package:my_app/components/my_habbit_tile.dart';
import 'package:my_app/components/my_heat_map.dart';
import 'package:my_app/database/habit_database.dart';
import 'package:my_app/models/habit.dart';
import 'package:my_app/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  //Create a new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: "Create a new habit"),
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: () {
                    //get new habit name
                    String newHabitName = textController.text;
                    //save to db
                    context.read<HabitDatabase>().addHabit(newHabitName);

                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),

                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  //Check habit on and off
  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status

    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  //Edit habit box
  void editHabitBox(Habit habit) {
    //set the controller' text to the habit's current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: () {
                    //get new habit name
                    String newHabitName = textController.text;
                    //save to db
                    context
                        .read<HabitDatabase>()
                        .updateHabitName(habit.id, newHabitName);

                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  //delete habit box
  void deleteHabitBox(Habit habit) {
    //set the controller' text to the habit's current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure do you want to delete?"),
              actions: [
                //delete button
                MaterialButton(
                  onPressed: () {
                    //save to db
                    context.read<HabitDatabase>().deleteHabit(habit.id);

                    //pop box
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      body: ListView(children: [_buildHeatMap(), _buildHabitsList()]),
      // body:  _buildHabitsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        // backgroundColor: Theme.of(context).colorScheme.tertiary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add,color: Theme.of(context).colorScheme.primary,),
      ),
    );
  }

  //build habit list
  Widget _buildHabitsList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habit list
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return habitlist return to UI

    return ListView.builder(
        shrinkWrap: true,
        itemCount: currentHabits.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //get each individual habit
          final habit = currentHabits[index];

          //check if the habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          //return habit tile UI

          return MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (value) => editHabitBox(habit),
            deleteHabit: (value) => deleteHabitBox(habit),
          );
        });
  }

  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //get current habit
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLauhchedDate(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits));
        } else {
          return Container();
        }
      },
    );
  }
}
