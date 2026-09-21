import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    final inputDecoration = InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        filled: true,
        suffixIcon: IconButton(
          onPressed: (){
            print("Box Value?");
          }, 
          icon: const Icon(Icons.send_rounded))
      );

    return TextFormField(
      decoration: inputDecoration,
      onFieldSubmitted: (value){
        print("Submit value: $value");
      },
      onChanged: (value) {
        print(value);
      },
    );
  }
} 