import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/core/api/api_services.dart';
import 'package:flutter_chatbot/core/repositories/user_repository.dart';
import 'package:flutter_chatbot/ui/constant/colors.dart';
import 'package:flutter_chatbot/ui/constant/textstyle.dart';
import 'package:flutter_chatbot/ui/responsiveState/responsive_state.dart';
import 'package:flutter_chatbot/ui/screens/recent_chat.dart';
import 'package:flutter_chatbot/ui/screens/response_screen.dart';
import 'package:flutter_chatbot/widget/user_image_widget.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      CustomNetworkImage(
                        imageUrl:
                            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3AProfile_avatar_placeholder_large.png&psig=AOvVaw3lFdiF0NVUAfUiwi4Q72a6&ust=1685445385764000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCKj3wsCzmv8CFQAAAAAdAAAAABAD",
                        radius: 50,
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
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.to(RecentScreen());
                          },
                          icon: Icon(Icons.history))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Type in mathematical problems to get a solution",
                    style: txStyle14.copyWith(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          color: appPrimaryColor1,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: TextFormField(
                          // maxLines: 20,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onEditingComplete: () async {
                            final userProv = Provider.of<UserRepository>(
                                context,
                                listen: false);
                            Get.to(ResponseScreen(
                              question: textEditingController.text,
                            ));

                            bool u = await userProv.sendMessageAndGetAnswers(
                                msg: textEditingController.text,
                                chosenModelId: userProv.getCurrentModel);

                            // if (u) {
                            //   userProv.fetchChat();
                            // }

                            setState(() {
                              textEditingController.clear();
                            });
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent",
                        style: txStyle16Bold,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(RecentScreen());
                        },
                        child: Text(
                          "view all >>",
                          style: txStyle12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userProv.chatHistoryModel.data?.isEmpty ?? true
                      ? Center(
                          child: Text(
                            "You are yet to ask a question!",
                            style: txStyle12.copyWith(color: Colors.grey),
                          ),
                        )
                      : MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  (userProv.chatHistoryModel.data!.length < 5)
                                      ? userProv.chatHistoryModel.data?.length
                                      : 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Dismissible(
                                    key: Key(index.toString()),
                                    background: Container(color: Colors.red),
                                    direction: DismissDirection.endToStart,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color:
                                              appPrimaryColor1.withOpacity(.5),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${userProv.chatHistoryModel.data?.reversed.elementAt(index).question}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: txStyle14Boldwt,
                                            ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${userProv.chatHistoryModel.data?.reversed.elementAt(index).answer}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: txStyle12wt,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
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
