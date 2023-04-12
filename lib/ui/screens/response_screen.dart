import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/ui/constant/textstyle.dart';
import 'package:flutter_chatbot/ui/responsiveState/responsive_state.dart';
import 'package:flutter_chatbot/ui/responsiveState/view_state.dart';
import 'package:flutter_chatbot/widget/customer_appbar.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/user_repository.dart';

class ResponseScreen extends StatefulWidget {
  final String question;
  const ResponseScreen({super.key, required this.question});

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
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
                  style: txStyle14,
                ),
                Icon(
                  Icons.edit,
                  size: 15,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.question,
              textAlign: TextAlign.left,
              style: txStyle12.copyWith(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Response",
                  style: txStyle14,
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
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading the best solution. be patient",
                      style: txStyle14.copyWith(color: Colors.grey),
                    ),
                  ],
                )),
                idleWidget: Text(
                  userProv.content,
                  style: txStyle12,
                ))
          ],
        ),
      ),
    );
  }
}
