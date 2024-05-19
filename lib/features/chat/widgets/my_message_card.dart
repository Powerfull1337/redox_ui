import 'package:flutter/material.dart';
import 'package:redox_ui/colors.dart';
import 'package:redox_ui/common/enums/message_enum.dart';
import 'package:redox_ui/features/chat/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  // final VoidCallback onLeftSwipe;
  // final String repliedText;
  // final String username;
  // final MessageEnum repliedMessageType;
  // final bool isSeen;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    // required this.onLeftSwipe,
    // required this.repliedText,
    //required this.username,
    //required this.repliedMessageType,
    //required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  padding: type == MessageEnum.text ? const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ): const EdgeInsets.only(left:5, top: 5, right: 5, bottom: 25),
                  child: DisplayTextImageGIF(message: message, type: type)),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}