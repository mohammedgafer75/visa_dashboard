import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/model/employes_model.dart';
import 'package:visa_dashboard/model/user_model.dart';
import 'package:visa_dashboard/widgets/custom_button.dart';
import 'package:visa_dashboard/widgets/custom_textfield.dart';

import '../model/customer_model.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';

class EmployeeController extends GetxController {
  RxList<Employee> customers = RxList<Employee>([]);
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController email, name, number;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("employee");
    name = TextEditingController();
    email = TextEditingController();
    number = TextEditingController();
    customers.bindStream(getAllCustomers());
    loading.value = true;
    super.onInit();
  }
 String? validate(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }
  Stream<List<Users>> getAllUsers() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());
  Stream<List<Employee>> getAllCustomers() => FirebaseFirestore.instance
      .collection('employee')
      .snapshots()
      .map((query) =>
          query.docs.map((item) => Employee.fromMap(item)).toList());
           void addRoom(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final data = MediaQuery.of(context);
    Get.defaultDialog(
        // title: 'Add Room',
        content: SizedBox(
      height: data.size.height / 2,
      width: data.size.width / 2,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            
            CustomTextField(
              controller: name,
              validator: (value) {
                return validate(value!);
              },
              lable: 'employee name',
              icon: const Icon(Icons.bed),
              input: TextInputType.text,
              secure: false,
            ),
            CustomTextField(
              controller: email,
              validator: (value) {
                return validate(value!);
              },
              lable: 'employee email',
              icon: const Icon(Icons.description),
              input: TextInputType.text,
              secure: false,
            ),
            CustomTextField(
              controller: number,
              validator: (value) {
                return validate(value!);
              },
              lable: 'employee number',
              icon: const Icon(Icons.money),
              input: TextInputType.number,
              secure: false,
            ),
           
            MaterialButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  
                    showdilog();
      
                    try {
                      var data = <String, dynamic>{
                        "name": name.text,
                        "email": email.text,
                        "number": int.tryParse(number.text),
                        
                      };
                      await collectionReference
                          .doc()
                          .set(data)
                          .whenComplete(() async {
                        name.clear();
                        number.clear();
                        email.clear();
                       
                        Get.back();
                        
                        showbar('title', 'subtitle', 'employee Added', true);
                        update();
                      });
                    } catch (e) {
                      Get.back();

                      showbar('title', 'subtitle', e.toString(), false);
                    }
                  
                }
              },
              child: const Text("Add employee"),
              // minWidth: double.infinity,
              // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
              height: 52,
              elevation: 24,
              color: Colors.amber.shade700,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
            const SizedBox(
              height: 5,
            ),
            MaterialButton(
              onPressed: () async {
                Get.back();
              },
              child: const Text("close"),
              // minWidth: double.infinity,
              // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
              height: 52,
              elevation: 24,
              color: Colors.amber.shade700,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
          ],
        ),
      ),
    ));
  }
  void deleteCustomer(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Customer delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                FirebaseFirestore.instance
                    .collection('customers')
                    .doc(id)
                    .delete();
                Get.back();
                Get.back();
                showbar('Delete Customer', '', 'Customer Deleted', true);
              } catch (e) {
                showbar('Delete Customer ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }
}
