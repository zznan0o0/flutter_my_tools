import 'dart:io';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path/path.dart' as path;
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
  Future<void> _mergeVideos(String directoryPath) async {
    String outputPath = '/my_tools_application/ffmpeg';
    final Directory outputDirectory = Directory(outputPath);
    if (!await outputDirectory.exists()) {
      await outputDirectory.create(recursive: true);
    }
    try {
      final directory = Directory(directoryPath);
      if(!await directory.exists()){
        throw Exception("目录不存在");
      }

      final List<FileSystemEntity> entities = await directory.list().toList();
      for(final entity in entities){
        Directory childDirectory = Directory(entity.path);
        final List<FileSystemEntity> files = await childDirectory.list().toList();
        List<String> fileNames = [];
        final String currentDirName = path.basename(childDirectory.path);
        for(final file in files){
          // 获取文件名
          fileNames.add(file.path);
        }

        fileNames.sort((a, b) {
          final int numA = extractNumberFromFileName(a);
          final int numB = extractNumberFromFileName(b);
          return numA.compareTo(numB);
        });

        List<String> fileAllPaths = [];
        for(final filePath in fileNames){
          fileAllPaths.add('$outputPath/$currentDirName/${path.basename(filePath)}');
        }

        final result = await FFmpegKit.execute(
          '-i "concat:${fileAllPaths.join("|")}" -c copy $outputPath/$currentDirName.mp4',
        );

      }
    
    } catch (e) {
      LogUtil.error(e);
    }
  }

  Future<void> mergeM3U8ToMP4(String directoryPath, String outputPath) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw Exception("目录不存在");
      }

      final List<FileSystemEntity> entities = await directory.list().toList();
      for (final entity in entities) {
        if (entity is Directory) {
          final List<FileSystemEntity> files = await entity.list().toList();
          List<String> m3u8Files = [];
          for (final file in files) {
            if (path.extension(file.path).toLowerCase() == '.m3u8') {
              m3u8Files.add(file.path);
            }
          }

          for (final m3u8File in m3u8Files) {
            final String currentDirName = path.basename(entity.path);
            final String outputFilePath = '$outputPath/$currentDirName.mp4';

            final result = await FFmpegKit.execute(
              '-i "$m3u8File" -c copy "$outputFilePath"',
            );

            final returnCode = await result.getReturnCode();
            if (ReturnCode.isSuccess(returnCode)) {
              LogUtil.info("成功合并: $outputFilePath");
            } else {
              LogUtil.info('合并失败: $outputFilePath');
            }
          }
        }
      }
    } catch (e) {
      LogUtil.error('发生错误: $e');
    }
  }

  int extractNumberFromFileName(String fileName) {
    final RegExp regExp = RegExp(r'\d+');
    final Match? match = regExp.firstMatch(path.basename(fileName));
    if (match != null) {
      return int.parse(match.group(0)!);
    }
    return 0; // 如果文件名中没有数字，默认返回0
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
      if(result!.isNotEmpty){
        mergeM3U8ToMP4(result, '/my_tools_application/ffmpeg');
      }
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