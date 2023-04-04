import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbot/ui/constant/textstyle.dart';
import 'package:flutter_chatbot/ui/responsiveState/responsive_state.dart';
import 'package:flutter_chatbot/ui/screens/chat_screen.dart';
import 'package:flutter_chatbot/ui/screens/signup_screen.dart';
import 'package:flutter_chatbot/widget/custom_button_load.dart';
import 'package:flutter_chatbot/widget/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserRepository>(context);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Welcome Back!",
                    style: txStyle27Bold,
                  ),
                  SizedBox(
                    height: 20,
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
                ],
              ),
              SizedBox(
                height: 20,
              ),
              CustomButtonLoad(
                  onTap: () async {
                    bool u = await userProv.login(
                        _emailController.text, _passwordcontroller.text);
                    if (u) {
                      userProv.userProfile();
                      userProv.fetchChat();

                      Get.to(ChatScreen());
                    }
                  },
                  label: "Login",
                  userProv: userProv.state),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.to(SignupScreen());
                },
                child: Text(
                  "Are you new? Signup",
                  style: txStyle14,
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
