import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/messages.dart';

class HerMessageBubble extends StatelessWidget {

  final Message message;

  const HerMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(message.text, style: TextStyle(color: Colors.white),),
          ),
        ),
        const SizedBox(height: 5,),
        Text(message.time, style: TextStyle(color: Color.fromARGB(243, 239, 239, 239)),),
        // _ImageBubble(),
        const SizedBox(height: 10,)
        // Todo: Image
      ],
    );
  }
}

class _ImageBubble extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        //'https://yesno.wtf/assets/no/7-331da2464250a1459cd7d41715e1f67d.gif',
        'https://media1.tenor.com/m/yZXjvQffRWEAAAAC/the-office-no.gif',
        height: 150, 
        width: size.width * 0.7,
        fit: BoxFit.cover,
        loadingBuilder:(context, child, loadingProgress){
          if(loadingProgress==null){
            return child;
          }
          return Container(
            width: size.width * 0.7,
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const Text("Cargando Imagen..."),
          );
        },));
  }
}