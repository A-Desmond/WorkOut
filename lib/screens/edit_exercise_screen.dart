import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout/blocs/workouts_cubit.dart';
import 'package:workout/helpers.dart';
import 'package:workout/model/workout.dart';

class EditExerciseScreen extends StatefulWidget {
  final WorkOut? workOut;
  final int index;
  final int? exindex;
  const EditExerciseScreen(
      {super.key, this.workOut, this.exindex, required this.index});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? _title;
  @override
  void initState() {
    _title = TextEditingController(
        text: widget.workOut!.exercises[widget.exindex!].title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: InkWell(
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController(
                              text: widget
                                  .workOut!.exercises[widget.exindex!].prelude
                                  .toString());
                          return AlertDialog(
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration:
                                  const InputDecoration(labelText: 'Prelude'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (controller.text.isNotEmpty) {
                                      Navigator.pop(context);
                                      setState(() {
                                        widget.workOut!
                                                .exercises[widget.exindex!] =
                                            widget.workOut!
                                                .exercises[widget.exindex!]
                                                .copyWith(
                                                    prelude: int.parse(
                                                        controller.text));
                                        BlocProvider.of<WorkOutsCubit>(context)
                                            .saveWorkOut(
                                                widget.workOut!, widget.index);
                                      });
                                    }
                                  },
                                  child: const Text('Save'))
                            ],
                          );
                        }),
                    child: NumberPicker(
                      itemHeight: 30,
                      value:
                          widget.workOut!.exercises[widget.exindex!].prelude!,
                      minValue: 0,
                      maxValue: 3599,
                      textMapper: (strVal) =>
                          formatTime(int.parse(strVal), false),
                      onChanged: (value) => setState(() {
                        widget.workOut!.exercises[widget.exindex!] = widget
                            .workOut!.exercises[widget.exindex!]
                            .copyWith(prelude: value);
                        BlocProvider.of<WorkOutsCubit>(context)
                            .saveWorkOut(widget.workOut!, widget.index);
                      }),
                    ))),
            Expanded(
                flex: 3,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _title,
                  onChanged: (value) => setState(() {
                    widget.workOut!.exercises[widget.exindex!] = widget
                        .workOut!.exercises[widget.exindex!]
                        .copyWith(title: value);
                    BlocProvider.of<WorkOutsCubit>(context)
                        .saveWorkOut(widget.workOut!, widget.index);
                  }),
                )),
            Expanded(
                child: InkWell(
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController(
                              text: widget
                                  .workOut!.exercises[widget.exindex!].prelude
                                  .toString());
                          return AlertDialog(
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration:
                                  const InputDecoration(labelText: 'Prelude'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (controller.text.isNotEmpty) {
                                      Navigator.of(context).pop;
                                      setState(() {
                                        widget.workOut!
                                                .exercises[widget.exindex!] =
                                            widget.workOut!
                                                .exercises[widget.exindex!]
                                                .copyWith(
                                                    duration: int.parse(
                                                        controller.text));
                                        BlocProvider.of<WorkOutsCubit>(context)
                                            .saveWorkOut(
                                                widget.workOut!, widget.index);
                                      });
                                    }
                                  },
                                  child: const Text('Save'))
                            ],
                          );
                        }),
                    child: NumberPicker(
                      itemHeight: 30,
                      value:
                          widget.workOut!.exercises[widget.exindex!].duration!,
                      minValue: 0,
                      maxValue: 3599,
                      textMapper: (strVal) =>
                          formatTime(int.parse(strVal), true),
                      onChanged: (value) => setState(() {
                        widget.workOut!.exercises[widget.exindex!] = widget
                            .workOut!.exercises[widget.exindex!]
                            .copyWith(duration: value);
                        BlocProvider.of<WorkOutsCubit>(context)
                            .saveWorkOut(widget.workOut!, widget.index);
                      }),
                    ))),
          ],
        )
      ],
    );
  }
}
