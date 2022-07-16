import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/controller/customer_controller.dart';
import 'package:visa_dashboard/controller/employee_controller.dart';

class EmployesPage extends StatelessWidget {
const EmployesPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
   final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: GetX<EmployeeController>(
        init: EmployeeController(),
        autoRemove: false,
        builder: (logic) {
          return logic.loading.value
              ? SizedBox(
                  height: data.size.height,
                  width: data.size.width,
                  child: Stack(children: [
                    logic.customers.isEmpty
                        ? const Center(
                            child: Text('No employees founded'),
                          )
                        : ListView.builder(
                            itemCount: logic.customers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text('${logic.customers[index].name}'),
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      backgroundColor: Colors.blue,
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                            'Number: ${logic.customers[index].number}'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              'email: ${logic.customers[index].email}'),
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
                                                logic.customers[index].id!);
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
                          logic.addRoom(context);
                        },
                        child: const Text("Add Room"),
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
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}