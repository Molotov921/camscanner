import 'package:get/get.dart';
import 'package:camscanner/models/file_model.dart';
import 'package:camscanner/services/database_service.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class Controller extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final logger = Logger();

  var files = <FileModel>[].obs; // Observable list of files
  var photos = <String>[].obs; // Observable list of photos

  Future<void> createFile(String name) async {
    final file = FileModel(
        id: DateTime.now().millisecondsSinceEpoch, name: name, photos: []);
    try {
      await _databaseService.insertFile(file);
    } catch (e) {
      logger.e("Error creating file: $e");
    }
  }

  Future<void> addPhotoToFile(int fileId, String photoPath) async {
    try {
      final files = await _databaseService.getFiles();
      final file = files.firstWhere((file) => file.id == fileId);
      file.photos.add(photoPath);
      await _databaseService.insertFile(file);
      this.files.refresh(); // Update observable list
    } catch (e) {
      logger.e("Error adding photo to file: $e");
    }
  }

  Future<void> exportPhotosAsPdf(int fileId) async {
    try {
      final files = await _databaseService.getFiles();
      final file = files.firstWhere((file) => file.id == fileId);

      final pdf = pw.Document();
      for (var photoPath in file.photos) {
        final image = pw.MemoryImage(File(photoPath).readAsBytesSync());
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image));
            },
          ),
        );
      }

      final output = await getTemporaryDirectory();
      final pdfFile = File("${output.path}/document.pdf");
      await pdfFile.writeAsBytes(await pdf.save());
      logger.i("PDF exported successfully to ${pdfFile.path}");
    } catch (e) {
      logger.e("Error exporting photos as PDF: $e");
    }
  }

  Future<img.Image> cropPhoto(
      img.Image image, int x, int y, int width, int height) async {
    try {
      return img.copyCrop(image, x, y, width, height);
    } catch (e) {
      logger.e("Error cropping photo: $e");
      return image;
    }
  }

  Future<img.Image> applyFilter(
      img.Image image, int red, int green, int blue) async {
    try {
      return img.colorOffset(image, red: red, green: green, blue: blue);
    } catch (e) {
      logger.e("Error applying filter: $e");
      return image;
    }
  }
}
