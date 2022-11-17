import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/workout_cubit.dart';
import 'package:workout/blocs/workouts_cubit.dart';
import 'package:workout/helpers.dart';
import 'package:workout/model/workout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Work Out',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon:const  Icon(Icons.event_available)),
          IconButton(onPressed: () {}, icon:const  Icon(Icons.settings)),
        ],
      ),
      backgroundColor: Colors.grey[500],
      body: SingleChildScrollView(
        child: BlocBuilder<WorkOutsCubit, List<WorkOut>>(
            builder: (context, workoutState) {
          return ExpansionPanelList.radio(
              children: workoutState
                  .map((workOut) => ExpansionPanelRadio(
                      value: workOut,
                      headerBuilder: (BuildContext context, bool isExpanded) =>
                          ListTile(
                            onTap: () => !isExpanded ?BlocProvider.of<WorkOutCubit>(context).startWorkOut(workOut):null,
                            visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: VisualDensity.maximumDensity),
                            leading: IconButton(
                                onPressed: (){
                                  BlocProvider.of<WorkOutCubit>(context).editWorkOut(workOut, workoutState.indexOf(workOut));
                                } , icon: const Icon(Icons.edit)),
                            title: Text(workOut.title!),
                            trailing: Text(
                              formatTime(workOut.getTotal(), true),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                      body: ListView.builder(
                          shrinkWrap: true,
                          itemCount: workOut.exercises.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: (){},
                              visualDensity: const VisualDensity(
                                  horizontal: 0,
                                  vertical: VisualDensity.maximumDensity),
                              leading: Text(formatTime(
                                  workOut.exercises[index].prelude!, true)),
                              title: Text(workOut.exercises[index].title!),
                              trailing: Text(formatTime(
                                  workOut.exercises[index].duration!, true)),
                            );
                          })))
                  .toList());
        }),
      ),
    );
  }
}
