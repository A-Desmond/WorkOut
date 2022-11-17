import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout/blocs/workout_cubit.dart';
import 'package:workout/helpers.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/state/workout_state.dart';

class WorkProgress extends StatelessWidget {
  const WorkProgress({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> getStats(WorkOut workout, int worktimeElapsed) {
      int getWorkOutTotal = workout.getTotal();
      Exercise exercise = workout.getCurrentExercise(worktimeElapsed);
      int exerciseElapsed = worktimeElapsed - exercise.startTime!;
      int exerciseRemaining = exercise.prelude! - exerciseElapsed;
      bool isPrelude = exerciseElapsed < exercise.prelude!;
      int exerciseTotal = isPrelude ? exercise.prelude! : exercise.duration!;
      if (!isPrelude) {
        exerciseElapsed -= exercise.prelude!;
        exerciseRemaining += exercise.duration!;
      }
      return {
        'workoutTitle': workout.title,
        'isPrelude': isPrelude,
        'workOutProgress': worktimeElapsed / getWorkOutTotal,
        'workOutElapsed': worktimeElapsed,
        'totalExercise': workout.exercises.length,
        'currentExerciseIndex': exercise.index!.toDouble(),
        'workOutRemaining': getWorkOutTotal - worktimeElapsed,
        'exerciseRemaining': exerciseRemaining,
        'exerciseProgress': exerciseElapsed / exerciseTotal
      };
    }

    return Container(
      child: Center(
        child: BlocConsumer<WorkOutCubit, WorkOutState>(
          builder: (context, state) {
            final stats = getStats(state.workOut!, state.elapsed!);
            return Scaffold(
                appBar: AppBar(
                  title: Text(state.workOut!.title.toString()),
                  leading: BackButton(onPressed: () {
                    BlocProvider.of<WorkOutCubit>(context).goHome();
                  }),
                ),
                body: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        color: Colors.blue[900],
                        minHeight: 10,
                        value: stats['workOutProgress'],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(stats['workOutElapsed'], true),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                            ),
                            DotsIndicator(
                              dotsCount: stats['totalExercise'],
                              position: stats['currentExerciseIndex'],
                            ),
                            Text(
                              '-${formatTime(stats['workOutRemaining'], true)}',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (state is WorkOutInProgress) {
                            BlocProvider.of<WorkOutCubit>(context)
                                .pauseWorkOut();
                          } else if (state is WorkOutPaused) {
                            BlocProvider.of<WorkOutCubit>(context)
                                .resumeWorkOut();
                          }
                        },
                        child: Stack(
                          alignment: const Alignment(0, 0),
                          children: [
                            Center(
                              child: SizedBox(
                                height: 220,
                                width: 220,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      stats['isPrelude']
                                          ? Colors.red
                                          : Colors.blue),
                                  strokeWidth: 25,
                                  value: stats['exerciseProgress'],
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Image.asset('assets/stopwatch.png'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ));
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
