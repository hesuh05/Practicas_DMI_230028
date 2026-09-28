import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/domain/entities/messages.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/1385/1385850.png'),
          ),
        ),
        title: Text("alita233"),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final chatProvider = context.watch<ChatProvider>();
    DateTime time = DateTime.now();
    String lastDate = "${time.day}/${time.month}/${time.year}";
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: chatProvider.messageList.length,
              controller: chatProvider.chatScrollController,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
                bool newSection = lastDate!=message.date;
                DateTime time = DateTime.now();
                String sectionTitle = message.date==lastDate?"Today":lastDate;
                lastDate = message.date; 
                return message.fromWho==FromWho.origin
                ? MyMessageBubble(message: message, header: sectionTitle, showHeader: newSection)
                : HerMessageBubble(message: message, header: sectionTitle, showHeader: newSection);
              },
            )),
            // Caja de Texto
            MessageFieldBox(
              onValue: (value) => chatProvider.sendMessage(value)
            )
          ],
        ),
      ),
    );
  }
}