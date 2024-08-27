import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tools_application/helper/deferred_router.dart';
import 'package:my_tools_application/page/ffmpeg_tool_page.dart' deferred as deferred_ffmpeg_tool_page;
import 'package:my_tools_application/page/mybatis_where_tool_page.dart' deferred as deferred_mybatis_where_tool_page;
import 'package:my_tools_application/page/home_page.dart';
import 'package:my_tools_application/utils/log_util.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RouteConfig{
  static const String home = '/';
  static const String ffmpegToolPage = "/ffmpegToolPage";
  static const String debugPage = "/debugPage";
  static const String mybatisWhereToolPage = "/mybatisWhereToolPage";

  static final List<GetPage> getPages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: ffmpegToolPage, page: () => DeferredRouter(future: deferred_ffmpeg_tool_page.loadLibrary(), builder: (_) => deferred_ffmpeg_tool_page.FFmpegToolPage())),
    GetPage(name: mybatisWhereToolPage, page: () => DeferredRouter(future: deferred_mybatis_where_tool_page.loadLibrary(), builder: (_) => deferred_mybatis_where_tool_page.MybatisWhereToolPage())),
    GetPage(name: debugPage, page: () => TalkerScreen(talker: LogUtil.talker)),

  ];

}