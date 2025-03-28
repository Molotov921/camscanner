import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfView extends StatelessWidget {
  final pdf = pw.Document();

  PdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF View'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _generatePdf(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Text('PDF Generated');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _savePdf();
              },
              child: const Text('Save PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World'),
          );
        },
      ),
    );
  }

  Future<void> _savePdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
