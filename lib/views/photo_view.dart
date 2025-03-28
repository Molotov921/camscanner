import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:camscanner/controllers/controller.dart';
import 'dart:io';
import 'dart:typed_data';

class PhotoView extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  PhotoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo View'),
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
                    final decodedImage =
                        img.decodeImage(File(photo).readAsBytesSync());
                    return decodedImage != null
                        ? ListTile(
                            leading: Image.memory(
                              Uint8List.fromList(img.encodeJpg(decodedImage)),
                            ),
                            title: Text('Photo ${index + 1}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.crop),
                              onPressed: () {
                                _showCropDialog(context, photo);
                              },
                            ),
                          )
                        : const ListTile(
                            title: Text('Invalid Image'),
                          );
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filter to selected photo
              },
              child: const Text('Apply Filter'),
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
          title: const Text('Crop Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: xController,
                decoration: const InputDecoration(hintText: 'X'),
              ),
              TextField(
                controller: yController,
                decoration: const InputDecoration(hintText: 'Y'),
              ),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(hintText: 'Width'),
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(hintText: 'Height'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final x = int.tryParse(xController.text) ?? 0;
                final y = int.tryParse(yController.text) ?? 0;
                final width = int.tryParse(widthController.text) ?? 100;
                final height = int.tryParse(heightController.text) ?? 100;

                final originalImage =
                    img.decodeImage(File(photoPath).readAsBytesSync());
                if (originalImage != null) {
                  final croppedImage =
                      controller.cropPhoto(originalImage, x, y, width, height);
                  // Optionally, save the cropped image to file
                }

                Navigator.of(context).pop();
              },
              child: const Text('Crop'),
            ),
          ],
        );
      },
    );
  }
}
