import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visa_dashboard/widgets/custom_textfield.dart';
import 'package:path/path.dart';
import '../model/service_model.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';

class ServicesController extends GetxController {
  RxList<Service> services = RxList<Service>([]);
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController name,
      address,
      phone,
      email,
      status,
      roomNumber,
      number;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    collectionReference = firebaseFirestore.collection("service");
    address = TextEditingController();
    roomNumber = TextEditingController();
    status = TextEditingController();
    email = TextEditingController();
    name = TextEditingController();
    number = TextEditingController();
    phone = TextEditingController();
    services.bindStream(getAllService());
    loading.value = true;
    super.onInit();
  }

  Stream<List<Service>> getAllService() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Service.fromMap(item)).toList());
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

  void addService(BuildContext context) {
    name.clear();
    address.clear();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final data = MediaQuery.of(context);
    Get.defaultDialog(
        title: 'Add Hotel',
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
                  controller: name,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'Hotel name',
                  icon: const Icon(Icons.bed),
                  input: TextInputType.text,
                  secure: false,
                ),
                CustomTextField(
                  controller: number,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'Hotel number',
                  icon: const Icon(Icons.numbers),
                  input: TextInputType.text,
                  secure: false,
                ),
                CustomTextField(
                  controller: address,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'address',
                  icon: const Icon(Icons.money),
                  input: TextInputType.text,
                  secure: false,
                ),
                CustomTextField(
                  controller: phone,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'phone',
                  icon: const Icon(Icons.money),
                  input: TextInputType.number,
                  secure: false,
                ),
                CustomTextField(
                  controller: email,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'email',
                  icon: const Icon(Icons.money),
                  input: TextInputType.emailAddress,
                  secure: false,
                ),
                CustomTextField(
                  controller: status,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'status',
                  icon: const Icon(Icons.money),
                  input: TextInputType.text,
                  secure: false,
                ),
                CustomTextField(
                  controller: roomNumber,
                  validator: (value) {
                    return validate(value!);
                  },
                  lable: 'number of room',
                  icon: const Icon(Icons.money),
                  input: TextInputType.number,
                  secure: false,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        showdilog();
                        await uploadImageToFirebase();
                        var data = <String, dynamic>{
                          "name": name.text,
                          "address": address.text,
                          "status": status.text,
                          "email": email.text,
                          "image": image_url,
                          "phone": int.tryParse(phone.text),
                          "number": int.tryParse(number.text),
                          "roomNumber": int.tryParse(roomNumber.text),
                        };
                        await collectionReference
                            .doc()
                            .set(data)
                            .whenComplete(() async {
                          update();
                          name.clear();
                          address.clear();
                          Get.back();
                          showbar('title', 'subtitle', 'hotel Added', true);
                        });
                      } catch (e) {
                        Get.back();
                        showbar('title', 'subtitle', e.toString(), false);
                      }
                    }
                  },
                  child: const Text("Add service"),
                  minWidth: double.infinity,
                  // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
                  height: 52,
                  elevation: 24,
                  color: Colors.amber.shade700,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: const Text("close"),
                  minWidth: double.infinity,
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

  // void editService(String id, BuildContext context, String name1, int price1) {
  //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //   final data = MediaQuery.of(context);
  //   name.text = name1;
  //   price.text = price1.toString();
  //   Get.defaultDialog(
  //       // title: 'Add Room',
  //       content: SizedBox(
  //     height: data.size.height / 2,
  //     width: data.size.width / 2,
  //     child: Form(
  //       key: formKey,
  //       child: ListView(
  //         children: [
  //           CustomTextField(
  //             controller: name,
  //             validator: (value) {
  //               return validate(value!);
  //             },
  //             lable: 'service name',
  //             icon: const Icon(Icons.bed),
  //             input: TextInputType.text,
  //             secure: false,
  //           ),
  //           CustomTextField(
  //             controller: price,
  //             validator: (value) {
  //               return validate(value!);
  //             },
  //             lable: 'price',
  //             icon: const Icon(Icons.money),
  //             input: TextInputType.number,
  //             secure: false,
  //           ),
  //           MaterialButton(
  //             onPressed: () async {
  //               try {
  //                 showdilog();
  //                 var data = <String, dynamic>{
  //                   "name": name.text,
  //                   "price": int.tryParse(price.text),
  //                 };
  //                 await collectionReference
  //                     .doc(id)
  //                     .update(data)
  //                     .whenComplete(() async {
  //                   name.clear();
  //                   price.clear();
  //                   Get.back();
  //                   Get.back();
  //                   showbar('title', 'subtitle', 'Service Edited', true);
  //                   update();
  //                 });
  //               } catch (e) {
  //                 Get.back();
  //                 showbar('title', 'subtitle', e.toString(), false);
  //               }
  //             },
  //             child: const Text("Edit service"),
  //             // minWidth: double.infinity,
  //             // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
  //             height: 52,
  //             elevation: 24,
  //             color: Colors.amber.shade700,
  //             textColor: Colors.black,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(32)),
  //           ),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           MaterialButton(
  //             onPressed: () async {
  //               Get.back();
  //             },
  //             child: const Text("close"),
  //             // minWidth: double.infinity,
  //             // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
  //             height: 52,
  //             elevation: 24,
  //             color: Colors.amber.shade700,
  //             textColor: Colors.black,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(32)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ));
  // }

  void deleteService(String id) {
    Get.dialog(AlertDialog(
      content: const Text('service delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await collectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete hotel', '', 'hotel Deleted', true);
              } catch (e) {
                showbar('Delete hotel ', '', e.toString(), false);
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
