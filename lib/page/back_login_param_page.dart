import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:get/get.dart';
import 'package:my_tools_application/page/layout/back_layout.dart';
import 'package:json_annotation/json_annotation.dart';

part 'back_login_param_page.g.dart'; 

class BackLoginParamPage extends StatelessWidget {
  BackLoginParamPage({super.key});
  final BackLoginParamPageController controller = Get.put(BackLoginParamPageController());

  @override
  Widget build(BuildContext context) {
    return BackLayout(title: "测后台跳登录参数", 
      body: Center(child: 
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(maxLines: null, controller: controller.userIdEditingController, decoration: const InputDecoration(hintText: "请输入userId", border: OutlineInputBorder())),
              TextField(maxLines: null, controller: controller.secretKeyEditingController, decoration: const InputDecoration(hintText: "请输入secretKey", border: OutlineInputBorder())),
              Row(children: [
                TextButton(onPressed: controller.generate, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("生成↓")),
                TextButton(onPressed: controller.copy, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("复制结果"),),
              ]),
              Obx(() => HighlightView(
                  // The original code to be highlighted
                  controller.result.value,

                  // Specify language
                  // It is recommended to give it a value for performance
                  language: 'json',

                  // Specify highlight theme
                  // All available themes are listed in `themes` folder
                  theme: githubTheme,

                  // Specify padding
                  padding: const EdgeInsets.all(12),

                  // Specify text style
                  textStyle: const TextStyle(
                    fontFamily: 'My awesome monospace font',
                    fontSize: 16,
                  ),
                )
              )
            ]
          )
        )
        
      ),
    );
  }
}

class BackLoginParamPageController extends GetxController{
  RxString result = "".obs;

  final secretKeyEditingController = TextEditingController();
  final userIdEditingController = TextEditingController();

  void setResult(String result){
    this.result.value = result;
  }

  void clearTextField() {
    secretKeyEditingController.clear();
    userIdEditingController.clear();
  }

  void copy() async{
    await Clipboard.setData(ClipboardData(text: result.value));
  }

  void generate(){
    String userId = userIdEditingController.text;
    String secretKey = secretKeyEditingController.text;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String dataToEncrypt = 'userId=$userId&timestamp=$timestamp&secretKey=$secretKey';
    List<int> bytes = utf8.encode(dataToEncrypt); // Data in bytes
    Digest sha256Digest = sha256.convert(bytes);

    // Convert the digest to a hexadecimal string
    String signature = sha256Digest.toString();



    ParamResult paramResult = ParamResult(
      userId: userId,
      secretKey: secretKey,
      timestamp: timestamp,
      signature: signature
    );
    String jsonString = jsonEncode(paramResult.toJson());
     setResult(jsonString);
  }
}

@JsonSerializable()
class ParamResult{
  ParamResult({
    this.userId,
    this.secretKey,
    this.timestamp,
    this.signature
  });

  String? userId;
  String? secretKey;
  int? timestamp;
  String? signature;

  factory ParamResult.fromJson(Map<String, dynamic> json) => _$ParamResultFromJson(json);
  Map<String, dynamic> toJson() => _$ParamResultToJson(this);
}