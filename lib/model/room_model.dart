import 'package:cloud_firestore/cloud_firestore.dart';

class Rooms {
  String? id;
  int? personNumber;
  String? image;
  String? description;
  int? price;
  int? number;
  int? hotelNumber;
  Rooms(
      {this.id,
      required this.personNumber,
      required this.price,
      required this.number,
      required this.hotelNumber,
      required this.image,
      required this.description});

  Rooms.fromMap(DocumentSnapshot data) {
    id = data.id;
    personNumber = data["personNumber"];
    price = data["price"];
    number = data["number"];
    hotelNumber = data["hotelNumber"];
    image = data["image"];
    description = data["description"];
  }
}
