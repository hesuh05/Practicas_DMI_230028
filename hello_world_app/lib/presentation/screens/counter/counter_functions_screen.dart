import 'package:flutter/material.dart';

class CounterFunctionsScreen extends StatefulWidget {
  const CounterFunctionsScreen({super.key});

  @override
  State<CounterFunctionsScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterFunctionsScreen> {
  int clickcounter = 0;
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Functions'),
        actions: [
          IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () {},
        )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickcounter',
              style: TextStyle(fontSize: 160, fontWeight: FontWeight.w100, color: clickcounter<0?Colors.red:clickcounter>0?Colors.green:Colors.blue),
            ),
            Text(
              "Click${clickcounter != 1 ? 's' : ''}",
              style: TextStyle(fontSize: 25, fontFamily: 'Roboto'),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  clickcounter = 0;
                });
              },
              child: Icon(Icons.exposure_zero),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
        onPressed: () {
          setState(() {
            clickcounter++;
          });
        },
        child: Icon(Icons.exposure_plus_1_rounded),
      ),
      SizedBox(height: 15),
      FloatingActionButton(
        onPressed: () {
          setState(() {
            clickcounter--;
          });
        },
        child: Icon(Icons.exposure_minus_1_rounded),
      )
        ],
      ),
    );
  }
}
