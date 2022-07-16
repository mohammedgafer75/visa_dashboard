import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/controller/service_controller.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);
  static const String id = "Services-screen";
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: GetX<ServicesController>(
          init: ServicesController(),
          autoRemove: false,
          builder: (logic) {
            return logic.loading.value
                ? SizedBox(
                    height: data.size.height,
                    width: data.size.width,
                    child: Stack(children: [
                      logic.services.isEmpty
                          ? const Center(
                              child: Text('No Hotel founded'),
                            )
                          : ListView.builder(
                              itemCount: logic.services.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.all(10),
                                    child: ListTile(
                                      title: Text('Hotel Name:'+ logic.services[index].name!),
                                      leading: CircleAvatar(
                                        child: Text('${index + 1}',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        backgroundColor: Colors.blue,
                                      ),
                                      subtitle:
                                          Text('Hotel Number: ${logic.services[index].number}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // IconButton(
                                          //     onPressed: () {
                                          //       logic.editService(
                                          //           logic.services[index].id!,
                                          //           context,
                                          //           logic.services[index].name!,
                                          //           logic.services[index].price!);
                                          //     },
                                          //     icon: const Icon(Icons.edit)),
                                          IconButton(
                                            onPressed: () {
                                              logic.deleteService(
                                                  logic.services[index].id!);
                                            },
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: data.size.height / 1.3,
                            left: data.size.width / 3,
                            right: data.size.width / 3),
                        child: MaterialButton(
                          onPressed: () {
                            logic.addService(context);
                          },
                          child: const Text("Add Hotel"),
                          minWidth: double.infinity,
                          // padding: EdgeInsets.only(left: data.size.width /2 ,right: data.size.width),
                          height: 52,
                          elevation: 24,
                          color: Colors.blue,
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                    ]),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
