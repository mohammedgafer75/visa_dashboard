import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? id;
  String? name;
  String? email;
  int? number;


  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.number,

  });

  Employee.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    email = data["email"];
    number = data["number"];
  }
}