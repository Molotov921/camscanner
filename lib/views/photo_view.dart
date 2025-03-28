import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:camscanner/controllers/controller.dart';

class PhotoView extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo View'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.photos.length,
                  itemBuilder: (context, index) {
                    final photo = controller.photos[index];
                    return ListTile(
                      leading: Image.file(File(photo)),
                      title: Text('Photo ${index + 1}'),
                      trailing: IconButton(
                        icon: Icon(Icons.crop),
                        onPressed: () {
                          _showCropDialog(context, photo);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filter to selected photo
              },
              child: Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCropDialog(BuildContext context, String photoPath) {
    final TextEditingController xController = TextEditingController();
    final TextEditingController yController = TextEditingController();
    final TextEditingController widthController = TextEditingController();
    final TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Crop Photo'),
          content: Column(
            children: [
              TextField(
                controller: xController,
                decoration: InputDecoration(hintText: 'X'),
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(hintText: 'Y'),
              ),
              TextField(
                controller: widthController,
                decoration: InputDecoration(hintText: 'Width'),
              ),
              TextField(
                controller: heightController,
                decoration: InputDecoration(hintText: 'Height'),
              ),
            ],
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
                final x = int.parse(xController.text);
                final y = int.parse(yController.text);
                final width = int.parse(widthController.text);
                final height = int.parse(heightController.text);
                controller.cropPhoto(photoPath, x, y, width, height);
                Navigator.of(context).pop();
              },
              child: Text('Crop'),
            ),
          ],
        );
      },
    );
  }
}
