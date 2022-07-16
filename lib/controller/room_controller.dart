import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/model/room_model.dart';
import 'package:visa_dashboard/widgets/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../widgets/loading.dart';
import '../widgets/snackbar.dart';

class RoomsController extends GetxController {
  RxList<Rooms> rooms = RxList<Rooms>([]);
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController personNumber,
      price,
      number,
      description,
      hotelNumber;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  // @override
  // void onReady() {
  //  loading.value = true;
  //   super.onReady();
  // }
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("room");
    price = TextEditingController();
    personNumber = TextEditingController();
    number = TextEditingController();
    description = TextEditingController();
    hotelNumber = TextEditingController();
    rooms.bindStream(getAllRooms());
    loading.value = true;
    super.onInit();
  }

  Stream<List<Rooms>> getAllRooms() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Rooms.fromMap(item)).toList());
  String? validate(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }

  final ImagePicker _picker = ImagePicker();
  List<FilePickerResult?> image = [];
  void imageSelect() async {
    final FilePickerResult? selectedImage =
        await FilePicker.platform.pickFiles();
    if (selectedImage!.files.isNotEmpty) {
      image.clear();
      image.add(selectedImage);
      showbar('select image', 'subtitle', 'image selected', true);
      update();
    }
  }

  // final _pickedImages = [];
  // Future<void> _pickImage() async {
  //   final fromPicker = await ImagePickerPlugin;
  //   if (fromPicker != null) {
  //       _pickedImages.clear();
  //       _pickedImages.add(fromPicker);
  //       await uploadImageToFirebase();
  //       update();
  //   }
  // }
  late String image_url;
  Future uploadImageToFirebase() async {
    String fileName = basename(image[0]!.files.single.name);
    var file = image[0]!.files.single.bytes;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putData(
        file!,
        SettableMetadata(
            contentType: 'image/${image[0]!.files.single.extension}'));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    await taskSnapshot.ref.getDownloadURL().then(
          (value) => image_url = value,
        );
  }

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
            GestureDetector(
              onTap: () async {
                imageSelect();
              },
              child: Container(
                height: data.size.height * 0.20,
                width: data.size.width * 0.05,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(46),
                ),
                child: image.isEmpty
                    ? const Center(child: Icon(Icons.add_a_photo_outlined))
                    : const Center(
                        child: Text(
                          'image Selected',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
              ),
            ),
            CustomTextField(
              controller: personNumber,
              validator: (value) {
                return validate(value!);
              },
              lable: 'person Number',
              icon: const Icon(Icons.bed),
              input: TextInputType.number,
              secure: false,
            ),
            CustomTextField(
              controller: description,
              validator: (value) {
                return validate(value!);
              },
              lable: 'room description',
              icon: const Icon(Icons.description),
              input: TextInputType.text,
              secure: false,
            ),
            CustomTextField(
              controller: price,
              validator: (value) {
                return validate(value!);
              },
              lable: 'price',
              icon: const Icon(Icons.money),
              input: TextInputType.number,
              secure: false,
            ),
            CustomTextField(
              controller: hotelNumber,
              validator: (value) {
                return validate(value!);
              },
              lable: 'hotel number',
              icon: const Icon(Icons.bed),
              input: TextInputType.number,
              secure: false,
            ),
            CustomTextField(
              controller: number,
              validator: (value) {
                return validate(value!);
              },
              lable: 'room number',
              icon: const Icon(Icons.bed),
              input: TextInputType.number,
              secure: false,
            ),
            MaterialButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (image.isNotEmpty) {
                    showdilog();
                    await uploadImageToFirebase();
                    try {
                      var data = <String, dynamic>{
                        "personNumber": int.tryParse(personNumber.text),
                        "number": int.tryParse(number.text),
                        "hotelNumber": int.tryParse(hotelNumber.text),
                        "price": int.tryParse(price.text),
                        "image": image_url,
                        "description": description.text,
                        "check": false
                      };
                      await collectionReference
                          .doc()
                          .set(data)
                          .whenComplete(() async {
                        personNumber.clear();
                        number.clear();
                        price.clear();
                        description.clear();
                        Get.back();
                        image.clear();
                        showbar('title', 'subtitle', 'Room Added', true);
                        update();
                      });
                    } catch (e) {
                      Get.back();

                      showbar('title', 'subtitle', e.toString(), false);
                    }
                  } else {
                    showbar('title', 'subtitle', "please select image", false);
                  }
                }
              },
              child: const Text("Add room"),
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

  void editRoom(
      String id, BuildContext context, int type1, int price1, String desc) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final data = MediaQuery.of(context);
    personNumber.text = type1.toString();
    description.text = desc;
    price.text = price1.toString();
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
              controller: personNumber,
              validator: (value) {
                return validate(value!);
              },
              lable: 'person Number',
              icon: const Icon(Icons.bed),
              input: TextInputType.text,
              secure: false,
            ),
            CustomTextField(
              controller: price,
              validator: (value) {
                return validate(value!);
              },
              lable: 'price',
              icon: const Icon(Icons.money),
              input: TextInputType.number,
              secure: false,
            ),
            CustomTextField(
              controller: description,
              validator: (value) {
                return validate(value!);
              },
              lable: 'description',
              icon: const Icon(Icons.money),
              input: TextInputType.number,
              secure: false,
            ),
            MaterialButton(
              onPressed: () async {
                try {
                  showdilog();
                  var data = <String, dynamic>{
                    "type": personNumber.text,
                    "price": int.tryParse(price.text),
                    "description": description.text
                  };
                  await collectionReference
                      .doc(id)
                      .update(data)
                      .whenComplete(() async {
                    personNumber.clear();
                    price.clear();
                    description.clear();
                    Get.back();
                    Get.back();
                    showbar('title', 'subtitle', 'Room Edited', true);
                    update();
                  });
                } catch (e) {
                  Get.back();
                  showbar('title', 'subtitle', e.toString(), false);
                }
              },
              child: const Text("Edit room"),
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

  void deleteRoom(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Room delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await collectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete Room', '', 'Room Deleted', true);
              } catch (e) {
                showbar('Delete Room ', '', e.toString(), false);
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
