import 'package:complaint_user/utils/debugger.dart';
import 'package:flutter/foundation.dart';
import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/server.dart';

enum AppStatus { loading, serverMaintenance, suspended, completed }

class Manager {
  static bool _isLoadingOnStart = false;
  static ValueNotifier<AppStatus> status = ValueNotifier(AppStatus.loading);
  static late String latestAppVersion;
  static const bool isDev = true;
  static String language = 'en';

  static void restartApp() {
    _isLoadingOnStart = false;
  }

  static Future<void> processOnStart(data) async {
    User.loadDetails(data);
    //Debugger.log("TODO: IOS");
    //latestAppVersion = data['androidVersion'];
    Manager.status.value = AppStatus.completed;
  }

  static Future onStart() async {
    // prevent from calling twice
    try {
      if (!_isLoadingOnStart) {
        _isLoadingOnStart = true;
        Manager.status.value = AppStatus.loading;
        await User.loadJwtToken();
        Debugger.log("on starttttt");
        Debugger.log(User.jwt);
        final res = await Server.httpGet(Server.baseUrl, '/user/get', 'Error to fetch data on start');
        Debugger.log(res.body);
        if (res.code == 200) {
          processOnStart(res.body);
        } else if (res.code == 503 && res.body['code'] == 'maintenance') {
          Manager.status.value = AppStatus.serverMaintenance;
          return;
        } else {
          throw Exception('Error to fetch data on start');
        }
      }
    } catch (e) {
      Debugger.log(e);
      _isLoadingOnStart = false;
      throw Exception(e);
    }
  }
}
