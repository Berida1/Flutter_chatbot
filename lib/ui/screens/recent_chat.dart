import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/widget/customer_appbar.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/user_repository.dart';
import '../constant/colors.dart';
import '../constant/textstyle.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserRepository>(context);

    return Scaffold(
        appBar: CustomAppBar(
          title: "Recent",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              userProv.chatHistoryModel.data!.isEmpty
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
                          shrinkWrap: true,
                          itemCount: userProv.chatHistoryModel.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                    context: context,
                                    builder: (context) => ChatSheet(
                                        question:
                                            "${userProv.chatHistoryModel.data?.reversed.elementAt(index).question}",
                                        answer:
                                            "${userProv.chatHistoryModel.data?.reversed.elementAt(index).answer}"));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Dismissible(
                                  key: Key(index.toString()),
                                  background: Container(color: Colors.red),
                                  direction: DismissDirection.endToStart,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: appPrimaryColor1.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
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
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ));
  }
}

class ChatSheet extends StatelessWidget {
  final String question;
  final String answer;
  const ChatSheet({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: txStyle14Bold,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            answer,
            style: txStyle14,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
