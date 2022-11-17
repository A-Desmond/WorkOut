import 'package:equatable/equatable.dart';
import 'package:workout/model/workout.dart';

abstract class WorkOutState extends Equatable {
  final WorkOut? workOut;
  final int? elapsed;

  const WorkOutState(this.workOut, this.elapsed);
}

class WorkOutInitial extends WorkOutState {
  const WorkOutInitial() : super(null, 0);

  @override
  List<Object?> get props => [];
}

class WorkOutEditting extends WorkOutState{
  final int index;
  final int? exIndex;
  
  const WorkOutEditting(WorkOut? workOut,this.index, this.exIndex): super(workOut, 0);

  @override 
  List<Object?> get  props => [workOut, index, exIndex];
}

class WorkOutPaused extends WorkOutState{

  const WorkOutPaused(WorkOut ? workout, int ? elapsed): super(workout, elapsed);
  @override
  List<Object?> get props =>[workOut, elapsed];

}


class WorkOutInProgress extends  WorkOutState{
const   WorkOutInProgress( WorkOut? workOut,int? elapsed): super(workOut, elapsed);

  @override
  List<Object?> get props => [workOut, elapsed];
  }