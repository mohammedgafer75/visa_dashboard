import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:visa_dashboard/screens/change_password.dart';
import 'package:visa_dashboard/screens/customer_page.dart';
import 'package:visa_dashboard/screens/employes_page.dart';
import 'package:visa_dashboard/screens/room_management.dart';
import 'package:visa_dashboard/screens/services_screen.dart';

import '../controller/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _selectedScreen = const RoomManagement();
  final AuthController controller = Get.put(AuthController());

  currentScreen(item) {
    switch (item.route) {
      case RoomManagement.id:
        setState(() {
          _selectedScreen = const RoomManagement();
        });
        break;
      case CustomerPage.id:
        setState(() {
          _selectedScreen = const CustomerPage();
        });
        break;
      case ServicesPage.id:
        setState(() {
          _selectedScreen = const ServicesPage();
        });
        break;
      case ChangePassword.id:
        setState(() {
          _selectedScreen = const ChangePassword();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page'), actions: [
        IconButton(
            onPressed: () {
              controller.signOut();
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 7,
        ),
        padding: EdgeInsets.only(left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: const [
                Card_d(
                  icon: Icon(Icons.hotel, size: 30, color: Colors.white),
                  title: 'Room Management',
                  nav: RoomManagement(),
                ),
                Card_d(
                  icon: Icon(Icons.person, size: 30, color: Colors.white),
                  title: 'Customer Page',
                  nav: CustomerPage(),
                ),
                Card_d(
                  icon: Icon(Icons.hotel, size: 30, color: Colors.white),
                  title: 'Hotel Page',
                  nav: ServicesPage(),
                ),
                Card_d(
                  icon: Icon(Icons.person, size: 30, color: Colors.white),
                  title: 'Employees Page',
                  nav: EmployesPage(),
                ),
              ]),
        ),
      ),
    );
  }
}

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final dynamic icon;
  final dynamic nav;

  @override
  State<Card_d> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<Card_d> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      },
      child: Card(
        color: Colors.blueAccent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
