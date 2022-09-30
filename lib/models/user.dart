import 'package:complaint_user/utils/debugger.dart';
import 'package:complaint_user/utils/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum AuthState { loggedIn, loggedOut }

class User {
  static String name = 'C';
  static String? email;
  static String gender = '';
  static String? jwt = '';
  static String? role = '';
  static String campusId = 'campus-1';

  static ValueNotifier<AuthState> state = ValueNotifier(AuthState.loggedOut);

  static void loadDetails(Map details) {
    name = details['name'];
    email = details['email'];
    gender = details['gender'];
    role = details['role'];
    Debugger.log(role);
  }

  // static Future<void> register(String name, String gender) async {
  //   Map<String, String> _headers = {'Content-Type': 'application/json; charset=UTF-8'};
  //   const rootUrl = 'escroll.iium.edu.my';
  //   final Uri uri = Uri.https(rootUrl, '/api/mobile/register');
  //   final response = await http.post(
  //     uri,
  //     headers: _headers,
  //     body: jsonEncode({"email": email, "password": password, "unique_id": matricNo, "university_id": uniId}),
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body)['data'];
  //     name = data['name'];
  //     email = data['gender'];
  //     gender = data['gender'];
  //     const storage = FlutterSecureStorage();
  //     await storage.write(key: 'matricWallet', value: "$matricNo/$uniWallet");
  //     return null;
  //   } else {
  //     final errBody = jsonDecode(response.body);
  //     if (errBody['error'] != null) {
  //       return errBody['error'];
  //     }
  //     throw Exception('Something went wrong. Please try again.');
  //   }
  // }

  // return error code if error
  static Future<String?> signIn(String email, String password) async {
    String errorMessage = 'Error to sign in';
    final Map body = {'email': email, 'password': password};
    final result = await Server.httpPost(Server.baseUrl, '/user/login', body, errorMessage);
    if (result.code == 200) {
      saveJwtToken(result.body['token']);
      loadDetails(result.body);
      // state.value = AuthState.loggedIn;
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('loggedIn', true);
      return null;
    } else if (result.code == 404 || result.code == 400) {
      return result.body['code'];
    } else {
      throw Exception(errorMessage);
    }
  }

  static Future saveJwtToken(String token) async {
    jwt = token;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'jwt', value: token);
  }

  static Future loadJwtToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    jwt = await storage.read(key: 'jwt');
    if (jwt == null) {
      signOut();
    }
  }

  static Future<void> saveFcmToken() async {
    Debugger.log("TODO: FCM TOKEN");
    // try {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   final fcmTokenSaved = pref.getBool('fcmTokenSaved') ?? false;
    //   if (!fcmTokenSaved) {
    //     String? fcmToken = await FirebaseMessaging.instance.getToken();
    //     await Server.httpPut(
    //       Server.userBaseUrl,
    //       '/user/fcmtoken',
    //       {'fcmToken': fcmToken},
    //       'Failed to save fcm token',
    //     );
    //     await pref.setBool('fcmTokenSaved', true);
    //   }
    // } catch (err) {
    //   print(err);
    // }
  }

  static Future updateProfile(String newName, String newGender) async {
    await Server.httpPut(
      Server.baseUrl,
      '/user/edit',
      {'name': newName, 'gender': newGender},
      'Error to update profile',
    );
    name = newName;
    gender = newGender;
    return true;
  }

  static Future signOut() async {
    Debugger.log("log outttttttt");
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('loggedIn', false);
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    state.value = AuthState.loggedOut;
  }
}
