import 'package:get/get.dart';
import 'package:my_tools_application/helper/deferred_router.dart';
import 'package:my_tools_application/page/ffmpeg_tool_page.dart' deferred as deferred_ffmpeg_tool_page;
import 'package:my_tools_application/page/home_page.dart';

class RouteConfig{
  static const String home = '/';
  static const String ffmpegToolPage = "/ffmpegToolPage";

  static final List<GetPage> getPages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: ffmpegToolPage, page: () => DeferredRouter(future: deferred_ffmpeg_tool_page.loadLibrary(), builder: (_) => deferred_ffmpeg_tool_page.FFmpegToolPage()))

  ];

}