import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/state/workout_state.dart';

class WorkOutCubit extends Cubit<WorkOutState> {
  WorkOutCubit() : super(const WorkOutInitial());
  Timer? _timer;
  editWorkOut(WorkOut workOut, int index) =>
      emit(WorkOutEditting(workOut, index, null));

  editExercise(int exIndex) => emit(WorkOutEditting(
      state.workOut, (state as WorkOutEditting).index, exIndex));

  goHome() => emit(const WorkOutInitial());
  pauseWorkOut()=> emit(WorkOutPaused(state.workOut, state.elapsed));
   resumeWorkOut()=> emit(WorkOutInProgress(state.workOut, state.elapsed));

  onTick(Timer timer) {
    if (state is WorkOutInProgress) {
      WorkOutInProgress wip = state as WorkOutInProgress;
      if (wip.elapsed! < wip.workOut!.getTotal()) {
        emit(WorkOutInProgress(wip.workOut, wip.elapsed! + 1));
      } else {
        _timer!.cancel();
        Wakelock.disable();
        emit(const WorkOutInitial());
      }
    }
  }

  startWorkOut(WorkOut workOut, [int? index]) {
    Wakelock.enable();
    if (index != null) {
    } else {
      emit(WorkOutInProgress(workOut, 0));
    }

    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }
}
