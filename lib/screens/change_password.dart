import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visa_dashboard/widgets/custom_textfield.dart';
import 'package:visa_dashboard/widgets/loading.dart';
import 'package:visa_dashboard/widgets/snackbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  static const String id = "change-password";
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController repassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  auth.User? user = auth.FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return SizedBox(
      height: data.size.height,
      width: data.size.width,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTextField(
                  controller: oldpassword,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'please enter your old password ';
                    }
                  },
                  lable: 'old Password',
                  icon: Icon(Icons.lock),
                  input: TextInputType.text,
                  secure: false),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTextField(
                  controller: newpassword,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'please enter your new password ';
                    }
                  },
                  lable: 'new Password',
                  icon: Icon(Icons.lock),
                  input: TextInputType.text,
                  secure: false),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTextField(
                  controller: repassword,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'retype new password ';
                    }
                    if (newpassword.text != val) {
                      return 'password not matched';
                    }
                  },
                  lable: 'new Password',
                  icon: Icon(Icons.lock),
                  input: TextInputType.text,
                  secure: false),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    change_password();
                  }
                },
                child: const Text("change"),
                minWidth: double.infinity,
                height: 52,
                elevation: 24,
                color: Colors.amber.shade700,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  Future change_password() async {
    showdilog();
    AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email.toString(), password: oldpassword.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      var a = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await a.user!.updatePassword(newpassword.text);
      await a.user!.reload();
      setState(() {
        Navigator.of(context).pop();
        showbar(
            'change password', 'subtitle', 'Your Password is Updated ', true);
      });
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        Navigator.of(context).pop();
        oldpassword.clear();
        showbar(
            'change password', 'subtitle', 'Your Password Not Correct ', false);
      });
    }
  }
}
