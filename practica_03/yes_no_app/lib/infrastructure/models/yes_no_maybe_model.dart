import 'package:yes_no_app/domain/entities/messages.dart';

class YesNoMaybeModel {
  String answer;
  bool forced;
  String image;

  YesNoMaybeModel({
    required this.answer,
    required this.forced,
    required this.image
  });

  factory YesNoMaybeModel.fromJsonMap(Map<String, dynamic> json) =>
    YesNoMaybeModel(
      answer: json['answer'], 
      forced: json['forced'], 
      image: json['image']
    );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "forced": forced,
    "image": image
  };

  Message toMessageEntity() {
    DateTime time = DateTime.now();
    return Message(
    text: answer, 
    fromWho: FromWho.destiny, 
    time: "${time.hour}: ${time.minute}",
    imageUrl: image);
  }
}