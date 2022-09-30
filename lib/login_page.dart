import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/debugger.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  String? passwordError;
  String? emailError;
  bool hidePassword = true;
  bool isLoading = false;

  bool validate() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
    if (emailController.text.isEmpty) {
      setState(() => emailError = 'required');
      return false;
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = 'required');
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      String email = emailController.text;
      String password = passwordController.text;
      String? result = await User.signIn(email, password);
      Debugger.log(result);
      if (result == null) {
        User.state.value = AuthState.loggedIn;
        return;
      } else {
        if (result == 'invalid-email') {
          setState(() => emailError = 'Invalid email');
        } else if (result == 'user-not-found') {
          setState(() => emailError = 'User not found');
        } else if (result == 'wrong-password') {
          setState(() {
            passwordError = 'Wrong password';
            passwordController.clear();
          });
        } else {
          throw 'code result not recognized';
        }
      }
    } catch (e) {
      Debugger.log(e);
      setState(() {
        errorMessage = 'Something wrong. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            const SizedBox(height: 56.0),
            const Text('Login', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(labelText: 'Email', border: const OutlineInputBorder(), errorText: emailError),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16.0),
            TextField(
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                errorText: passwordError,
                suffixIcon: GestureDetector(
                  child: Icon(hidePassword ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
                  onTap: () => setState(() => hidePassword = !hidePassword),
                ),
              ),
              controller: passwordController,
              autofillHints: const [AutofillHints.password],
            ),
            errorMessage == null
                ? const SizedBox(height: 0)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(errorMessage!, style: const TextStyle(fontSize: 13, color: Colors.red)),
                  ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(isLoading ? 'Loading...' : 'Login'),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (validate()) {
                            await signIn();
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
