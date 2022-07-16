import 'package:cloud_firestore/cloud_firestore.dart';

class Customers {
  String? id;
  String? uid;
  String? name;
  String? email;
  int? number;


  Customers({
    this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.number,

  });

  Customers.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    email = data["email"];
    number = data["number"];
    uid = data["uid"];
  }
}