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
    return words.join('');
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
          sqlWhere = spByGroup[1];
          afterString = orderbyText + spByOrder[2];
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
        // 'not in',
        // 'NOT IN',
        // 'in',
        // 'IN',
      ];
      int i = 0;
      for(String andItem in andStrs){
        i++;
        String spStr = "";
        for(String ws in whereSymbols){
          if(andItem.contains(ws)){
            spStr = ws;
            break;
          }
        }
        if(spStr == ""){
          whereResults.add(andItem);
          continue;
        }
        List<String> fileds = andItem.split(spStr);
        String fieldName = fileds[0].trim();
        whereResults.add('''\n<if test="$fieldName != null and $fieldName != ''">${i > 1 ? '$andSp ' : ''}$fieldName$spStr#{${toLowerCamelCase(fieldName)}}</if>''');
        // String fieldStr = andItem.split(spStr);
      }
      whereString = whereResults.join('');
      controller.setResult('$beforeString$whereString$afterString');
    }
    else{
      controller.setResult(sql);
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