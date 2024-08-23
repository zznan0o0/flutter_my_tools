import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tools_application/router/route_config.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: GridView.count(crossAxisCount: 3, children: [
        createContain('FFmpeg视频工具', RouteConfig.ffmpegToolPage),
        createContain('FFmpeg视频工具', RouteConfig.ffmpegToolPage),
        createContain('FFmpeg视频工具', RouteConfig.ffmpegToolPage),
        createContain('FFmpeg视频工具', RouteConfig.ffmpegToolPage),
       ],),
    );
  }

  Widget createContain(String text, String uri){
    return GestureDetector(
      onTap: () => Get.toNamed(uri),
      child: Container(
        // padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 167, 167, 167), width: 1),
        ),
        child: Text(text),
      ),
    );
  }

}
