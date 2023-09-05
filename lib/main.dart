import 'package:alarm_app/controller/alarm_controller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? alarmTime;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          if (alarmTime != null)
            Text(DateFormat('dd-MMM-yyyy | hh:mm a').format(alarmTime!)),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100))
                  .then((date) async {
                if (date != null) {
                  await showTimePicker(
                          context: context, initialTime: TimeOfDay.now())
                      .then((time) {
                    if (time != null) {
                      alarmTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      setState(() {});
                    }
                  });
                }
              });
            },
            child: const Text('Pick Alarm Date & Time'),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              if (alarmTime != null) {
                await AlarmController.setAlarm(
                  id: DateTime.now().millisecond * 5,
                  alarmStartTime: alarmTime!,
                ).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alarm set successfully'),
                      ),
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select Alarm Time'),
                  ),
                );
              }
            },
            child: const Text('Set Alarm'),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              AlarmController.showAlarm(
                id: DateTime.now().millisecond * 5,
              );
            },
            child: const Text('Show Alarm'),
          ),
        ],
      ),
    );
  }
}
