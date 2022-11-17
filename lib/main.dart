import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout/blocs/workout_cubit.dart';
import 'package:workout/blocs/workouts_cubit.dart';
import 'package:workout/screens/edit_workout_screen.dart';
import 'package:workout/screens/home.dart';

import 'screens/workout_in_progress.dart';
import 'state/workout_state.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

 runApp(const WorkOutTime());
}

class WorkOutTime extends StatelessWidget {
  const WorkOutTime({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<WorkOutsCubit>(
            create: (BuildContext context) {
              WorkOutsCubit workOutCubit = WorkOutsCubit();
              if (workOutCubit.state.isEmpty) {
                workOutCubit.getWorkOuts();
              } else {}

              return workOutCubit;
            },
          ),
          BlocProvider<WorkOutCubit>(
              create: (BuildContext context) => WorkOutCubit())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Work Out',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: const TextTheme(
                    bodyText2:
                        TextStyle(color: Color.fromARGB(255, 66, 76, 96)))),
            home: BlocBuilder<WorkOutCubit, WorkOutState>(
                builder: (context, state) {
              if (state is WorkOutInitial) {
                return const HomePage();
              } else if (state is WorkOutEditting) {
                return const EditWorkOutScreen();
              }
              return const  WorkProgress();
            })));
  }
}
