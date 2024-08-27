import 'package:talker_flutter/talker_flutter.dart';

class LogUtil{
  static final Talker talker = TalkerFlutter.init();

  static void info(dynamic msg, [Object? exception, StackTrace? stackTrace]){
    talker.info(msg, exception, stackTrace);
  }

  static void error(dynamic msg, [Object? exception, StackTrace? stackTrace]){
    talker.error(msg, exception, stackTrace);
  }

  static void debug(dynamic msg, [Object? exception, StackTrace? stackTrace]){
    talker.debug(msg, exception, stackTrace);
  }

  static void warning(dynamic msg, [Object? exception, StackTrace? stackTrace]){
    talker.warning(msg, exception, stackTrace);
  }

  
}