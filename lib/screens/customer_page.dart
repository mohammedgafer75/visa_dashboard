import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/controller/customer_controller.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({Key? key}) : super(key: key);
  static const String id = "customer-screen";
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: GetX<CustomersController>(
        init: CustomersController(),
        autoRemove: false,
        builder: (logic) {
          return logic.loading.value
              ? SizedBox(
                  height: data.size.height,
                  width: data.size.width,
                  child: Stack(children: [
                    logic.users.isEmpty
                        ? const Center(
                            child: Text('No Cutomers founded'),
                          )
                        : ListView.builder(
                            itemCount: logic.users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text('${logic.users[index].name}'),
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      backgroundColor: Colors.blue,
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                            'Number: ${logic.users[index].number}'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              'email: ${logic.users[index].email}'),
                                        )
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                        IconButton(
                                          onPressed: () {
                                            logic.deleteCustomer(
                                                logic.users[index].id!);
                                          },
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                  ]),
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
