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
          IconButton(icon: Icon(Icons.refresh_rounded), onPressed: () { 
            setState((){clickcounter = 0;})
            ;
          })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickcounter',
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w100,
                color: clickcounter < 0
                    ? Colors.red
                    : clickcounter > 0
                    ? Colors.green
                    : Colors.blue,
              ),
            ),
            Text(
              "Click${clickcounter != 1 ? 's' : ''}",
              style: TextStyle(fontSize: 25, fontFamily: 'Roboto'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Igualar a Cero
          CustomButton(icon: Icons.refresh_rounded, onPressed: () { setState((){ clickcounter = 0;}); },),
          SizedBox(height: 10),
          // Sumar uno
          CustomButton(icon: Icons.exposure_plus_1_rounded, onPressed: () { setState((){ clickcounter++; }); },),
          SizedBox(height: 10),
          // Restar uno
          CustomButton(icon: Icons.exposure_minus_1_rounded, onPressed: () { setState((){ clickcounter--; });},),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  
  final IconData icon;
  final VoidCallback? onPressed;
  
  const CustomButton({
    super.key,
    required this.icon,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      enableFeedback: true,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
