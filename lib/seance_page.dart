import 'package:flutter/material.dart';

class SeancePage extends StatefulWidget {
  const SeancePage({super.key});

  @override
  State<SeancePage> createState() => _SeancePageState();
}

class _SeancePageState extends State<SeancePage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('Seance Page')));
  }
}
