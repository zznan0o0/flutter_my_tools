import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
class FFmpegToolPage extends StatelessWidget{
  final FFmpegToolPageController controller = Get.put(FFmpegToolPageController());

  FFmpegToolPage({super.key});


  Future<void> _selectDirectory() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      print(result);
      controller.setDirectoryPath(result??"");
    } catch (e) {
      print(e);
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
              onPressed: _selectDirectory,
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