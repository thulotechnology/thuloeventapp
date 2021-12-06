import 'package:flutter/material.dart';
import './event_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
      },
      title: 'Thulo Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: EventList(),
    );
  }
}
