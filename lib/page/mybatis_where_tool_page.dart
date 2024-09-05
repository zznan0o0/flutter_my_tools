import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:get/get.dart';
import 'package:my_tools_application/page/layout/back_layout.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

class MybatisWhereToolPage extends StatelessWidget{
  MybatisWhereToolPage({super.key});

  final MybatisWhereToolPageController controller = Get.put(MybatisWhereToolPageController());


  String toLowerCamelCase(String input) {
    List<String> words = input.split('_');
    for (int i = 1; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }
    String result = words.join('');
    return result.substring(0, 1).toLowerCase() + result.substring(1);
  }

  void _copy() async{
    await Clipboard.setData(ClipboardData(text: controller.result.value));
  }

  void _generate(){
    String sql = controller.textFieldContent;
    String whereText = "where";
    String groupbyText = "group by";
    String orderbyText = "order by";
    if(sql.contains("WHERE")){
      whereText = "WHERE";
    }
    if(sql.contains("GROUP BY")){
      groupbyText = "GROUP BY";
    }
    if(sql.contains("ORDER BY")){
      orderbyText = "ORDER BY";
    }
    List<String> spByWhere = sql.split(whereText);
    String beforeString = "";
    String whereString = "";
    String afterString = "";
    if(spByWhere.length > 1){
      beforeString = spByWhere[0];
      String sqlWhere = spByWhere[1];
      List<String> spByGroup = sqlWhere.split(groupbyText);
      if(spByGroup.length > 1){
        sqlWhere = spByGroup[1];
        afterString = groupbyText + spByGroup[2];
      }
      else{
        List<String> spByOrder = sqlWhere.split(orderbyText);
        if(spByOrder.length > 1){
          sqlWhere = spByOrder[0];
          afterString = orderbyText + spByOrder[1];
        }
      }
      String andSp = "and";
      if(!sqlWhere.contains(andSp)){
        whereString = "AND";
      }
      List<String> andStrs = sqlWhere.split("and");
      List<String> whereResults = [];
      List<String> whereSymbols = [
        '!=',
        '>=',
        '<=',
        '=',
        'not like',
        'NOT LIKE',
        'like',
        'LIKE',
        'not in',
        'NOT IN',
        'in',
        'IN',
      ];

      List<String> inSymbols = [
        'not in',
        'NOT IN',
        'in',
        'IN',
      ];
      int i = 0;
      for(String andItem in andStrs){
        i++;
        String spStr = "";
        bool inFlag = false;
        for(String ws in whereSymbols){
          if(andItem.contains(ws)){
            spStr = ws;
            if(inSymbols.contains(ws)){
              inFlag = true;
            }
            break;
          }
        }
        if(spStr == ""){
          whereResults.add(andItem);
          continue;
        }
        List<String> fileds = andItem.split(spStr);
        String fieldName = fileds[0].trim();
        String lowerCamelCaseFieldName = toLowerCamelCase(fieldName);
        if(inFlag){
          whereResults.add('''\n<if test="$lowerCamelCaseFieldName != null and $lowerCamelCaseFieldName.size > 0">${i > 1 ? '$andSp ' : ''}$fieldName $spStr <foreach collection="$lowerCamelCaseFieldName" item="itemId" index="index" open="(" close=")" separator=",">#{itemId}</foreach></if>''');
        }
        else{
          whereResults.add('''\n<if test="$lowerCamelCaseFieldName != null and $lowerCamelCaseFieldName != ''">${i > 1 ? '$andSp ' : ''}$fieldName$spStr#{$lowerCamelCaseFieldName}</if>''');
        }
        // String fieldStr = andItem.split(spStr);
      }
      whereString = whereResults.join('');
      if(afterString.isNotEmpty){
        afterString = _replaceFirstEnglishCharWithNewline(afterString);
      }
      controller.setResult('$beforeString$whereString$afterString');
    }
    else{
      controller.setResult(sql);
    }
  }

  /// 使用正则表达式替换第一个英文字符之前的内容为换行符
String _replaceFirstEnglishCharWithNewline(String str) {
  // 正则表达式：匹配第一个英文字符之前的内容
  final regex = RegExp(r'^[^a-zA-Z]*([a-zA-Z])');
  final match = regex.firstMatch(str);

  if (match != null) {
    final index = match.start + match.group(0)!.length - 1;
    return '\n${str.substring(index)}';
  } else {
    return str; // 未找到英文字符，返回原字符串
  }
}

  @override
  Widget build(BuildContext context) {
    return BackLayout(title: "Mybatis Where语句生成工具", 
      body: Center(child: 
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(maxLines: null, controller: controller.textEditingController, decoration: const InputDecoration(hintText: "请输入SQL语句", border: OutlineInputBorder())),
              Row(children: [
                TextButton(onPressed: _generate, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("生成↓")),
                TextButton(onPressed: _copy, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: const Text("复制结果"),),
              ]),
              Obx(() => HighlightView(
                  // The original code to be highlighted
                  controller.result.value,

                  // Specify language
                  // It is recommended to give it a value for performance
                  language: 'xml',

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

class MybatisWhereToolPageController extends GetxController{
  RxString result = "".obs;

  final textEditingController = TextEditingController();

  String get textFieldContent => textEditingController.text;

  void setResult(String result){
    this.result.value = result;
  }

  void clearTextField() {
    textEditingController.clear();
  }

}