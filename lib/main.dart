import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbot/ui/screens/chat_screen.dart';
import 'package:flutter_chatbot/ui/screens/login_screen.dart';
import 'package:flutter_chatbot/ui/screens/splash_screen.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'core/repositories/provider.dart';

void main() {
  runApp(MultiProvider(providers: AppProviders.providers, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'SMat-Bot',
      theme: ThemeData(brightness: Brightness.light),
      home: SplashScreen(),
    );
  }
}
