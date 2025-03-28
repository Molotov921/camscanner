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
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.files.length,
                itemBuilder: (context, index) {
                  final file = controller.files[index];
                  return ListTile(
                    title: Text(file.name),
                    subtitle: Text('${file.photos.length} photos'),
                    onTap: () {
                      // Navigate to photo view
                    },
                  );
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: () {
              // Export photos as PDF
            },
            child: Text('Export as PDF'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFileNameDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showFileNameDialog(BuildContext context) {
    final TextEditingController fileNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter File Name'),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(hintText: 'File Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.createFile(fileNameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
