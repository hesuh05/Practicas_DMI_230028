import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_maybe_answer.dart';
import 'package:yes_no_app/domain/entities/messages.dart';

class ChatProvider extends ChangeNotifier {

  final ScrollController chatScrollController = ScrollController();
  final GetYesNoMaybeAnswer getYesNoMaybeAnswer = GetYesNoMaybeAnswer();

  List<Message> messageList = [
    Message(text: "What's up!", fromWho: FromWho.origin, time: "16:39"),
    Message(text: "sup 👍", fromWho: FromWho.destiny, time: "16:42"),
    Message(text: "You're near?", fromWho: FromWho.destiny, time: "16:45")
  ];

  Future<void> sendMessage(String text) async {
    if ( text.isEmpty ) return;

    DateTime time = DateTime.now();
    final newMessage = Message(text: text, fromWho: FromWho.origin, time: "${time.hour}:${time.minute}");
    messageList.add(newMessage);

    if (text.endsWith("?")) {
      await destinataryReply();
    }

    notifyListeners();
    await moveScrollToBottom();
  }

  Future<void> destinataryReply() async {
    final destinataryMessage = await getYesNoMaybeAnswer.getAnswer();
    messageList.add(destinataryMessage);
    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async{
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(chatScrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeOut
    );
  }
}