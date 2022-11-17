
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';

class WorkOutsCubit extends HydratedCubit<List<WorkOut>>{
  WorkOutsCubit():super([]);
  final List<WorkOut> workouts =[];
  getWorkOuts()async{
  final workoutsJson = jsonDecode( await rootBundle.loadString('assets/workouts.json'));
  for(var element in workoutsJson as Iterable){
    workouts.add(WorkOut.fromJson(element));
  }
  emit(workouts);
  }

  saveWorkOut(WorkOut workOut, int index){
  WorkOut newWorkOut =  WorkOut(title: workOut.title, exercises: []);
  int index = 0;
  int startTime = 0;
  for(var exer in workOut.exercises){
    newWorkOut.exercises.add(
      Exercise(
        title: exer.title, 
        prelude: exer.prelude, 
        duration: exer.duration,
        index: exer.index,
        startTime: exer.startTime,
        ),
    );
      index++;
      startTime += exer.prelude! +exer.duration!;  
  }

  state[index]= newWorkOut;
    emit([...state]);
    }
    
      @override
      List<WorkOut>? fromJson(Map<String, dynamic> json) {
           List<WorkOut> workouts = [];
           json['workouts'].forEach((json)=>workouts.add(WorkOut.fromJson(json)));
           return workouts;
      }
    
      @override
      Map<String, dynamic>? toJson(List<WorkOut> state) {
      if(state is List<WorkOut>){
         var json = {
        'workouts':[]
         };
         for(var workout in state){
          json['workouts']!.add(workout.toJson());
         }
         return json;
      }else{
        return null;
      }
      }
}