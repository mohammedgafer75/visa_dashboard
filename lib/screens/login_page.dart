import 'package:flutter/material.dart';
import 'package:visa_dashboard/widgets/login_page_left_side.dart';
import 'package:visa_dashboard/widgets/login_page_right_side.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 450,
            width: 1080,
            margin: EdgeInsets.symmetric(horizontal: 24),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Row(
              children: [
                LoginPageLeftSide(),
                // if (MediaQuery.of(context).size.width > 900)
                //   const LoginPageRightSide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
