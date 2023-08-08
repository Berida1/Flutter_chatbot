import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/ui/screens/chat_screen.dart';
import 'package:flutter_chatbot/ui/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/user_repository.dart';
import '../../widget/custom_button_load.dart';
import '../../widget/custom_textfield.dart';
import '../constant/colors.dart';
import '../constant/textstyle.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserRepository>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "SMat-Bot",
                style: txStyle16.copyWith(color: appPrimaryColor),
              ),
              Text(
                "A Secondary school mathematics chatbot",
                style: txStyle12,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Create an account!",
                      style: txStyle27Bold,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      labelText: "First name",
                      hintText: "john",
                      controller: _firstName,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      labelText: "Last name",
                      hintText: "Doe",
                      controller: _lastName,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      labelText: "Phone number",
                      hintText: "090********",
                      controller: _phone,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      labelText: "Email",
                      hintText: "johnDoe@gmail.com",
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      labelText: "Password",
                      hintText: "**********",
                      controller: _passwordcontroller,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButtonLoad(
                        onTap: () async {
                          bool u = await userProv.signUp(
                              _firstName.text,
                              _lastName.text,
                              "",
                              _emailController.text,
                              _phone.text,
                              _passwordcontroller.text);
                          if (u) {
                            Get.to(LoginScreen());
                          }
                        },
                        label: "Sign up",
                        userProv: userProv.state),
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
