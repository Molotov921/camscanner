import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camscanner/controllers/controller.dart';

class HomeView extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CamScanner App'),
      ),
      body: Center(
        child: Text('Home View'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
      ),
    );
  }
}