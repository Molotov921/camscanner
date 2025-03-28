import 'package:get/get.dart';
import 'package:camscanner/models/file_model.dart';
import 'package:camscanner/services/database_service.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Controller extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> createFile(String name) async {
    final file = FileModel(id: 0, name: name, photos: []);
    await _databaseService.insertFile(file);
  }

  Future<void> addPhotoToFile(int fileId, String photoPath) async {
    final files = await _databaseService.getFiles();
    final file = files.firstWhere((file) => file.id == fileId);
    file.photos.add(photoPath);
    await _databaseService.insertFile(file);
  }

  Future<void> exportPhotosAsPdf(int fileId) async {
    final files = await _databaseService.getFiles();
    final file = files.firstWhere((file) => file.id == fileId);

    final pdf = pw.Document();
    for (var photoPath in file.photos) {
      final image = pw.MemoryImage(await File(photoPath).readAsBytes());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(child: pw.Image(image));
      }));
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  Future<img.Image> cropPhoto(img.Image image, int x, int y, int width, int height) async {
    return img.copyCrop(image, x, y, width, height);
  }

  Future<img.Image> applyFilter(img.Image image, img.ColorFilter filter) async {
    return img.colorOffset(image, filter);
  }
}
