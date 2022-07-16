import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/model/user_model.dart';
import 'package:visa_dashboard/widgets/custom_button.dart';

import '../model/customer_model.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';

class CustomersController extends GetxController {
  RxList<Customers> customers = RxList<Customers>([]);
  RxList<Users> users = RxList<Users>([]);
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController email, name, number;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("users");
    name = TextEditingController();
    email = TextEditingController();
    number = TextEditingController();
    users.bindStream(getAllUsers());
    customers.bindStream(getAllCustomers());
    loading.value = true;
    super.onInit();
  }

  Stream<List<Users>> getAllUsers() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());
  Stream<List<Customers>> getAllCustomers() => FirebaseFirestore.instance
      .collection('customers')
      .snapshots()
      .map((query) =>
          query.docs.map((item) => Customers.fromMap(item)).toList());
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
