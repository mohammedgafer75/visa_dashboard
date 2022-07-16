import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/widgets/custom_textfield.dart';

import '../controller/auth_controller.dart';

class SignupLeftSide extends StatelessWidget {
  SignupLeftSide({Key? key}) : super(key: key);
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 120.0, left: 120),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextField(
              controller: controller.name,
              validator: (value) {
                return controller.validate(value!);
              },
              lable: 'Name',
              icon: const Icon(Icons.person),
              input: TextInputType.text,
              secure: false,
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
              controller: controller.number,
              validator: (value) {
                return controller.validateNumber(value!);
              },
              lable: 'Number',
              icon: const Icon(Icons.phone),
              input: TextInputType.number,
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
              secure: false,
            ),
            CustomTextField(
              controller: controller.repassword,
              validator: (value) {
                return controller.validateRePassword(value!);
              },
              lable: 'Retype Password',
              icon: const Icon(Icons.lock),
              input: TextInputType.number,
              secure: false,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            MaterialButton(
              onPressed: () {
                controller.register();
              },
              child: const Text("Sign up"),
              minWidth: double.infinity,
              height: 52,
              elevation: 24,
              color: Colors.amber.shade700,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
          ],
        ),
      ),
    ));
  }
}
