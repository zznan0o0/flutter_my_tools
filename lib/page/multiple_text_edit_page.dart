import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:get/get.dart';
import 'package:my_tools_application/page/layout/back_layout.dart';
import 'package:template_engine/template_engine.dart';

class MultipleTextEditPage extends StatelessWidget {
  final MultipleTextEditPageController controller = Get.put(MultipleTextEditPageController());

  MultipleTextEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackLayout(
      title: "分隔符编辑工具", 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: controller.inputTextController, maxLines: null, decoration: const InputDecoration(hintText: "输入文本内容", border: OutlineInputBorder())),
              TextField(controller: controller.splitTextController, maxLines: 1, decoration: const InputDecoration(hintText: "输入分割符号", border: OutlineInputBorder())),
              TextField(controller: controller.templateTextController, maxLines: null, decoration: const InputDecoration(hintText: "输入模版字符, {{}}标签，item是值。如{{item + '123'}}", border: OutlineInputBorder())),
              TextField(controller: controller.joinTextController, maxLines: null, decoration: const InputDecoration(hintText: "输入合并字符如,", border: OutlineInputBorder())),
              Row(children: [
                TextButton(onPressed: controller.generate, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("生成↓")),
                TextButton(onPressed: controller.copy, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("复制结果"),),
              ]),
              Obx(() => HighlightView(
                  controller.result.value,
                  language: 'java',
                  theme: githubTheme,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(
                    fontFamily: 'My awesome monospace font',
                    fontSize: 16,
                  ),
                )
              )
              
            ],
          ),
        ),
      )
    );
  }
}

class MultipleTextEditPageController extends GetxController{
  RxString result = "".obs;
  final inputTextController = TextEditingController();
  final splitTextController = TextEditingController();
  final templateTextController = TextEditingController();
  final joinTextController = TextEditingController();

  final engine = TemplateEngine();

  void copy() async{
    await Clipboard.setData(ClipboardData(text: result.value));
  }
  void generate() async {
    String inputText = inputTextController.text;
    String splitStr = splitTextController.text;
    String templateStr = templateTextController.text;
    List<String> splitList = inputText.split(splitStr);
    List<String> results = [];
    //await 后不需要Future<ParseResult>
    //有空可以看一下源码这个感觉比较强
    ParseResult parseResult = await engine.parseText(templateStr);
    
    for(String item in splitList){
        results.add((await engine.render(parseResult, {'item': item})).text);
    }
    result.value = results.join(joinTextController.text);
  }

}