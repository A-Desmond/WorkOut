import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/workout_cubit.dart';
import 'package:workout/blocs/workouts_cubit.dart';
import 'package:workout/helpers.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/screens/edit_exercise_screen.dart';
import 'package:workout/state/workout_state.dart';

class EditWorkOutScreen extends StatelessWidget {
  const EditWorkOutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOutCubit, WorkOutState>(builder: (context, state) {
      WorkOutEditting workOutEditting = state as WorkOutEditting;
      return Builder(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: InkWell(
                    child: Text(workOutEditting.workOut!.title!),
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController(
                              text: workOutEditting.workOut!.title);
                          return AlertDialog(
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  labelText: 'Work Out title'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (controller.text.isNotEmpty) {
                                      Navigator.pop(context);
                                      WorkOut renamedWorkOut = workOutEditting
                                          .workOut!
                                          .copyWith(newtitle:controller.text);
                                      BlocProvider.of<WorkOutsCubit>(context)
                                          .saveWorkOut(renamedWorkOut,
                                              workOutEditting.index);
                                      BlocProvider.of<WorkOutCubit>(context)
                                          .editWorkOut(renamedWorkOut,
                                              workOutEditting.index);
                                    }
                                  },
                                  child: const Text('Rename'))
                            ],
                          );
                        })),
                leading: BackButton(
                    onPressed: () =>
                        BlocProvider.of<WorkOutCubit>(context).goHome()),
              ),
              body: ListView.builder(
                  itemCount: workOutEditting.workOut!.exercises.length,
                  itemBuilder: (context, index) {
                    Exercise exercise = workOutEditting.workOut!.exercises[index];
                    if (workOutEditting.exIndex == index) {
                      return EditExerciseScreen(
                          workOut: workOutEditting.workOut,
                          index: workOutEditting.index,
                          exindex: workOutEditting.exIndex);
                    } else {
                      return ListTile(
                        leading: Text(formatTime(exercise.prelude!, true)),
                        title: Text(exercise.title!),
                        trailing: Text(formatTime(exercise.duration!, true)),
                        onTap: () => BlocProvider.of<WorkOutCubit>(context)
                            .editExercise(index),
                      );
                    }
                  }));
        }
      );
    });
  }
}


