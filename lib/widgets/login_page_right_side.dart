import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPageRightSide extends StatelessWidget {
  const LoginPageRightSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.orange,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/back.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SizedBox(
            height: 500,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 12, sigmaX: 12),
                      child: Container(
                          alignment: Alignment.topCenter,
                          color: Colors.white.withOpacity(.3),
                          padding: const EdgeInsets.all(42),
                          child: ListView(children: const [
                            Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 200,
                              height: 200,
                            ),
                            Text(
                              'Hotel Book DashBoard',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent),
                            )
                          ])),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 60.0),
                //     child: Image.asset('assets/images/woman.png', width: 300,),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
