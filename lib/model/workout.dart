import 'package:equatable/equatable.dart';
import 'package:workout/model/exercise.dart';

class WorkOut extends Equatable{
  final String ? title;
  final List<Exercise> exercises;

  const WorkOut({required this.title, required this.exercises});

  factory WorkOut.fromJson(Map<String, dynamic> json){
    List<Exercise> exercise = [];
    int index = 0;
    int startTime = 0;
    for(var ex in (json['exercises'] as Iterable)){
     exercise.add(Exercise.fromJson(ex, index, startTime));
     index++;
     startTime += exercise.last.prelude! +exercise.last.duration!;
    }
    return WorkOut(title:json['title'] as String?, exercises: exercise);

  }

  Map<String, dynamic> toJson()=>{
    'title':title,
    'exercises': exercises,
  };
  
int getTotal() =>exercises.fold(0, (prev, ex) => prev + ex.duration! + ex.prelude! );


Exercise getCurrentExercise(int ? elapsed)=> exercises.lastWhere((element) => element.startTime! < elapsed!);


WorkOut copyWith({String ? newtitle})=>WorkOut(title: newtitle??title, exercises: exercises);

  @override
  List<Object?> get props => [title, exercises];


}