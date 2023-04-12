import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/core/api/api_services.dart';
import 'package:flutter_chatbot/core/repositories/user_repository.dart';
import 'package:flutter_chatbot/ui/constant/textstyle.dart';
import 'package:flutter_chatbot/ui/responsiveState/responsive_state.dart';
import 'package:flutter_chatbot/ui/screens/response_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widget/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  bool _isTyping = false;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    ApiServices.getModels();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserRepository>(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveState(
          state: userProv.state,
          busyWidget: Center(
            child: Text(
              "Loading....",
              style: txStyle14,
            ),
          ),
          idleWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                final userProv =
                    Provider.of<UserRepository>(context, listen: false);
                await userProv.fetchChat();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userProv.userProfileModel.data?.firstName}",
                            style: txStyle14,
                          ),
                          Text(
                            "${userProv.userProfileModel.data?.email}",
                            style: txStyle12.copyWith(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF444654),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: TextField(
                          maxLines: 20,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          // onSubmitted: (value) async {
                          //   await sendMessageFCT(
                          //       modelsProvider: userProv, chatProvider: userProv);
                          // },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        final userProv =
                            Provider.of<UserRepository>(context, listen: false);
                        Get.to(ResponseScreen(
                          question: textEditingController.text,
                        ));

                        userProv.sendMessageAndGetAnswers(
                            msg: textEditingController.text,
                            chosenModelId: userProv.getCurrentModel);

                        setState(() {
                          textEditingController.clear();
                        });

                        // userProv.fetchChat();
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFF444654),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                            child: Text(
                          "Submit",
                          style: txStyle14wt,
                        )),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        "History",
                        style: txStyle16Bold,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // userProv.chatHistoryModel.data!.isEmpty
                  //     ? Center(
                  //         child: Text(
                  //           "You are yet to ask a question!",
                  //           style: txStyle12.copyWith(color: Colors.grey),
                  //         ),
                  //       )
                  //     :
                  // MediaQuery.removePadding(
                  //   context: context,
                  //   removeTop: true,
                  //   removeBottom: true,
                  //   child: ListView.builder(
                  //       shrinkWrap: true,
                  //       itemCount: userProv.chatHistoryModel.data?.length,
                  //       itemBuilder: (context, index) {
                  //         return Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "${userProv.chatHistoryModel.data?.elementAt(index).question}",
                  //               overflow: TextOverflow.ellipsis,
                  //               style: txStyle14,
                  //             ),
                  //             // SizedBox(
                  //             //   height: 10,
                  //             // ),
                  //             Text(
                  //               "${userProv.chatHistoryModel.data?.elementAt(index).answer}",
                  //               style: txStyle12.copyWith(color: Colors.grey),
                  //             ),
                  //           ],
                  //         );
                  //       }),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void scrollListToEND() {
  //   _listScrollController.animateTo(
  //       _listScrollController.position.maxScrollExtent,
  //       duration: const Duration(seconds: 2),
  //       curve: Curves.easeOut);
  // }

  Future<void> sendMessageFCT(
      {required UserRepository modelsProvider,
      required UserRepository chatProvider}) async {
    // if (_isTyping) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: Duration(seconds: 2),
    //       content: Text("You cant send multiple messages at a time",
    //           style: TextStyle(fontSize: 14)),
    //       backgroundColor: Color(0xFF444654),
    //     ),
    //   );
    //   return;
    // }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "If you don't give me what to solve, i wont solve anything",
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Color(0xFF444654),
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        // chatProvider.addUserMessage(msg: msg);
        // textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(error.toString()),
        backgroundColor: Color(0xFF444654),
      ));
    } finally {
      // setState(() {
      //   scrollListToEND();
      //   _isTyping = false;
      // });
    }
  }
}
