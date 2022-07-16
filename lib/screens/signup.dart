import 'package:flutter/material.dart';
import '../widgets/login_page_right_side.dart';
import '../widgets/sign_up_left_side.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 650,
            width: 1080,
            margin: EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Row(
              children: [
                 SignupLeftSide(),
                if (MediaQuery.of(context).size.width > 900)
                  const LoginPageRightSide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
