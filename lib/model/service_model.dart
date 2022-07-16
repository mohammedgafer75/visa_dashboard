import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String? id;
  String? name;
  String? address;
  String? image;
  String? status;
  String? email;
  int? number;
  int? roomNumber;
  int? phone;

  Service({
    this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.status,
    required this.email,
    required this.roomNumber,
    required this.phone,
    required this.number,
  });

  Service.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    address = data["address"];
    image = data["image"];
    status = data["status"];
    email = data["email"];
    roomNumber = data["roomNumber"];
    phone = data["phone"];
    number = data["number"];
  }
}
