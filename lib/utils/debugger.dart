import 'package:complaint_user/manager.dart';

class Debugger {
  static void log(dynamic msg) {
    if (Manager.isDev) {
      print("############################################");
      print(msg);
      print("############################################");
    }
  }
}