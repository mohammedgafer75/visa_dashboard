import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import 'custom_textfield.dart';

class LoginPageLeftSide extends StatelessWidget {
  LoginPageLeftSide({Key? key}) : super(key: key);
  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextField(
              controller: controller.email,
              validator: (value) {
                return controller.validateEmail(value!);
              },
              lable: 'Email',
              icon: const Icon(Icons.email),
              input: TextInputType.emailAddress,
              secure: false,
            ),
            CustomTextField(
              controller: controller.password,
              validator: (value) {
                return controller.validatePassword(value!);
              },
              lable: 'Password',
              icon: const Icon(Icons.lock),
              input: TextInputType.number,
              secure: true,
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: () {
                  controller.login();
                },
                child: const Text("Login"),
                minWidth: double.infinity,
                height: 52,
                elevation: 24,
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ));
  }
}
