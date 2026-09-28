import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/messages.dart';

class MyMessageBubble extends StatelessWidget {

  final Message message;
  final String header;
  final bool showHeader;

  const MyMessageBubble({super.key, required this.message, required this.header, required this.showHeader});

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        showHeader?Text(header):SizedBox(height: 0,),
        Container(
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(message.text, style: TextStyle(color: Colors.white),),
          ),
        ),
        Text(message.time, style: TextStyle(color: Color.fromARGB(243, 239, 239, 239)),),
        const SizedBox(height: 5,)
      ],
    );
  }
}