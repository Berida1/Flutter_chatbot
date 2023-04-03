import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatbot/core/api/api_services.dart';
import 'package:flutter_chatbot/core/api_utils/api_helper.dart';
import 'package:flutter_chatbot/core/api_utils/api_route.dart';
import 'package:flutter_chatbot/ui/responsiveState/base_view_model.dart';
import 'package:flutter_chatbot/ui/responsiveState/view_state.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/constant.dart';
import '../models/all_models_model.dart';
import '../models/chat_model.dart';

class UserRepository extends BaseNotifier {
  Map<String, String> get header => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer ${locator<UserInfoCache>().token}',
      };

  Future<Map<String, String>> headerWithToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString("token")!;

    Map<String, String> headerToken = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Token 47d6de34f2d596940332795bd6acf903e6318a05',
    };
    return headerToken;
  }

  List<ChatModel> chatList = [];
  String currentModel = "gpt-3.5-turbo-0301";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  // List<ChatModel> get getChatList {
  //   return chatList;
  // }

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiServices.getModels();
    return modelsList;
  }

  // void addUserMessage({required String msg}) {
  //   chatList.add(ChatModel(msg: msg, chatIndex: 0));
  //   notifyListeners();
  // }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiServices.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiServices.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }

  Future<bool> SendMessage(String message) async {
    setState(ViewState.Busy);
    try {
      log("modelId $currentModel");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": currentModel,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      setState(ViewState.Idle);
      return true;
    } catch (e) {
      displayError(title: "Error", message: e.toString());
      print(e);
      setState(ViewState.Idle);
      return false;
    }
  }

  Future<bool> addChat(String question, String answer) async {
    // log("${tx_ref}");
    setState(ViewState.Busy);
    try {
      Map val = {
        "question": question,
        "answer": answer,
      };
      var responsebody = await API()
          .post(apiRoute.addChat, await headerWithToken(), jsonEncode(val));
      // fetchQrcodeDataModel = fetchQrcodeDataModelFromJson(responsebody);
      setState(ViewState.Idle);
      return true;
    } catch (e) {
      displayError(title: "Error", message: e.toString());
      print(e);
      setState(ViewState.Idle);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    // log("${tx_ref}");
    setState(ViewState.Busy);
    try {
      Map val = {
        "email": email,
        "password": password,
      };
      var responsebody =
          await API().post(apiRoute.login, header, jsonEncode(val));
      // fetchQrcodeDataModel = fetchQrcodeDataModelFromJson(responsebody);
      setState(ViewState.Idle);
      return true;
    } catch (e) {
      displayError(title: "Error", message: e.toString());
      print(e);
      setState(ViewState.Idle);
      return false;
    }
  }

  Future<bool> signUp(String firstName, String lastName, String otherName,
      String email, String phoneNumber, String password) async {
    // log("${tx_ref}");
    setState(ViewState.Busy);
    try {
      Map val = {
        "firstName": firstName,
        "lastName": lastName,
        "otherNames": otherName,
        "email": email,
        "phone": phoneNumber,
        "password": password,
      };
      var responsebody =
          await API().post(apiRoute.signUp, header, jsonEncode(val));
      // fetchQrcodeDataModel = fetchQrcodeDataModelFromJson(responsebody);
      setState(ViewState.Idle);
      return true;
    } catch (e) {
      displayError(title: "Error", message: e.toString());
      print(e);
      setState(ViewState.Idle);
      return false;
    }
  }

  displayError({required String title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        title: title,
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
