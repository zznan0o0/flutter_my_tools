import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_tools_application/utils/dialog_util.dart';
import 'package:my_tools_application/utils/log_util.dart';
import 'package:permission_handler/permission_handler.dart';
class FFmpegToolPage extends StatelessWidget{
  final FFmpegToolPageController controller = Get.put(FFmpegToolPageController());

  FFmpegToolPage({super.key});

  Future<bool> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // ignore: unused_element
  Future<void> _mergeVideos() async {
    try {
      // 创建一个临时文件来存放 concat 指令
      final concatFile = await File('concat.txt').create();

      // 写入 concat 指令
      await concatFile.writeAsString('file video1.mp4\nfile video2.mp4');

      // 使用 concat 指令来合并视频
      // ignore: unused_local_variable
      final result = await FFmpegKit.execute(
        '-f concat -safe 0 -i ${concatFile.path} -c copy merged_video.mp4',
      );
    
    } catch (e) {
      LogUtil.error(e);
    }
  }


  Future<void> _selectDirectory(BuildContext context) async {
    try {
      //获取权限
      if(await _requestStoragePermission()){
        // ignore: use_build_context_synchronously
        DialogUtil.alert(context, "获取权限失败");
        throw Exception("获取权限失败");
      }
      final result = await FilePicker.platform.getDirectoryPath();
      controller.setDirectoryPath(result??"");
    } catch (e) {
      // ignore: avoid_print
      print(e);
      LogUtil.error("合并视频失败", e);
    }
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('FFmpeg视频工具'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDirectory(context),
              child: const Text('Select Directory'),
            ),
            // if (controller.directoryPath != '')
              Obx(() => Text('Selected directory: ${controller.directoryPath}')),
          ],
        ),),
    );
  }
  
}

class FFmpegToolPageController extends GetxController{
  RxString directoryPath = "".obs;

  void setDirectoryPath(String path){
    directoryPath.value = path;
  }


}