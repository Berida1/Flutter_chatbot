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
                  style: txStyle14Bold,
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
            Divider(),
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
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
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
