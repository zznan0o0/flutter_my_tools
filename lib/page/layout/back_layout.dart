import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 有返回按钮布局的组件
/// 返回上一页
class BackLayout extends StatelessWidget{
  final Widget body;
  final String title;
  const BackLayout({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: body
    );
  }
}