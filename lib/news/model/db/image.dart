import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


// Initialize Dio
Dio dio = Dio();

void download(String title, String downloadUrl) async {
  try {
    // Get the application documents directory
    var directory = await getApplicationDocumentsDirectory();

    // Download the file and save it locally
    await dio.download(downloadUrl, "${directory.path}/$title.extensionoffile",
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");
        });
  } catch (e) {
    // Handle any errors here
  }
}
Future<File> getImageFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/myImage.jpg'; // Replace with your image path
  return File(path);
}
