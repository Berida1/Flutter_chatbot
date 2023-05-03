import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/ui/constant/colors.dart';
import 'package:flutter_chatbot/ui/constant/textstyle.dart';
import 'package:flutter_chatbot/ui/responsiveState/responsive_state.dart';
import 'package:flutter_chatbot/ui/responsiveState/view_state.dart';
import 'package:flutter_chatbot/widget/custom_button_load.dart';
import 'package:flutter_chatbot/widget/customer_appbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../../core/repositories/user_repository.dart';

class ResponseScreen extends StatefulWidget {
  final String question;
  const ResponseScreen({super.key, required this.question});

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  final TextEditingController textEditingController = TextEditingController();
  late FocusNode focusNode;
  bool isEditable = true;
  bool isSpeaking = false;
  TextToSpeech tts = TextToSpeech();
  @override
  void initState() {
    super.initState();
    final userProv = Provider.of<UserRepository>(context, listen: false);

    textEditingController.text = widget.question;
    focusNode = FocusNode();
  }

  // FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserRepository>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Response",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question",
                  style: txStyle14Bold,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isEditable = !isEditable;
                      if (!isEditable) {
                        focusNode.requestFocus();
                      }
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    size: 15,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // maxLines: 20,
              readOnly: isEditable,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.black),
              controller: textEditingController,
              onEditingComplete: () async {
                final userProv =
                    Provider.of<UserRepository>(context, listen: false);

                bool u = await userProv.sendMessageAndGetAnswers(
                    msg: textEditingController.text,
                    chosenModelId: userProv.getCurrentModel);

                // if (u) {
                //   userProv.fetchChat();
                // }
              },
              decoration: const InputDecoration.collapsed(
                  hintText: "How can I help you?",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            // Text(
            //   widget.question,
            //   textAlign: TextAlign.left,
            //   style: txStyle12.copyWith(color: Colors.grey),
            // ),
            Divider(),
            !isEditable
                ? Text(
                    "Press enter to send",
                    style: txStyle12.copyWith(color: Colors.grey),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Response",
                  style: txStyle14Bold,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ResponsiveState(
                state: userProv.state,
                busyWidget: Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    SpinKitCubeGrid(
                      color: appPrimaryColor,
                      size: 50.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading the best solution. Please be patient",
                      style: txStyle14.copyWith(color: Colors.grey),
                    ),
                  ],
                )),
                idleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProv.content,
                      style: txStyle12,
                    ),
                    Divider(),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (isSpeaking == false) {
                                tts.speak(userProv.content);
                                setState(() {
                                  isSpeaking = true;
                                });
                              } else {
                                tts.pause();
                                setState(() {
                                  isSpeaking = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.volume_up,
                              color: appPrimaryColor,
                            )),
                        isSpeaking
                            ? Text(
                                "Tap to pause",
                                style: txStyle14,
                              )
                            : Text(
                                "Tap to Text to speech",
                                style: txStyle14,
                              )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        userProv.sendMessageAndGetAnswers(
                            msg: textEditingController.text,
                            chosenModelId: userProv.getCurrentModel);
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appPrimaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Not satisfied? Regenerate response",
                            style: txStyle13wt,
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

//   Future _speak() async{
//     var result = await flutterTts.speak("Hello World");
//     // if (result == 1) setState(() => ttsState = TtsState.playing);
// }

// Future _stop() async{
//     var result = await flutterTts.stop();
//     // if (result == 1) setState(() => ttsState = TtsState.stopped);
// }
}
