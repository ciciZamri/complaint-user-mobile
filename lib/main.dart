import 'package:complaint_user/home_page.dart';
import 'package:complaint_user/login_page.dart';
import 'package:complaint_user/manager.dart';
import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/debugger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadUser();
  runApp(const App());
}

Future<void> loadUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLoggedIn = pref.getBool('loggedIn') ?? false;
  if (isLoggedIn) {
    User.state.value = AuthState.loggedIn;
  } else {
    User.state.value = AuthState.loggedOut;
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Complaint',
      initialRoute: '/root',
      routes: {
        '/root': (context) => const Root(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        buttonTheme: ButtonThemeData(
          disabledColor: Colors.green[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          height: 48.0,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.disabled) ? Colors.green[200] : Colors.green;
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        ),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    User.state.addListener(() {
      Navigator.popUntil(context, ModalRoute.withName('/root'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: User.state,
      builder: (context, AuthState state, _) {
        Debugger.log(state);
        if (state == AuthState.loggedIn) {
          return Material(
            child: FutureBuilder(
              future: Manager.onStart(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Debugger.log(snapshot.error);
                  return Column(children: [
                    Container(
                      width: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 48.0, bottom: 16.0),
                        child: Center(
                          child: Text(
                            'Complaint',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      color: Colors.lightGreen,
                    ),
                    const SizedBox(height: 125),
                    const Icon(Icons.wifi_off_rounded, size: 84),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Please check your internet connection\n and try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(onPressed: () => setState(() {}), child: const Text('Try again'))
                  ]);
                }
                return ValueListenableBuilder(
                  valueListenable: Manager.status,
                  builder: (context, AppStatus status, _) {
                    if (status == AppStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const HomePage();
                    }
                  },
                );
              },
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

// class UserSuspendedPage extends StatelessWidget {
//   const UserSuspendedPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Text('Your User was suspended'),
//     );
//   }
// }