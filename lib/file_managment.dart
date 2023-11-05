import 'dart:io';

class FileManagement {
  String? homePath;
  late Directory appDirectory;

  FileManagement() {
    homePath =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  }

  void createFolder() {
    // Create a folder in the home directory
    appDirectory =
        Directory('$homePath/projects/dart_password_manager/testFolder');

    // Create the folder if it doesn't already exist
    if (!appDirectory.existsSync()) {
      appDirectory.create();
      print('Folder created successfully.');
    } else {
      print('Folder already exists.${appDirectory.path}');
    }
  }

//! this function can not create an aes file only txt files;
//   void createFile() {
// // Create a text file in the folder
//     File file = File('${appDirectory.path}/my_file.txt.aes');

//     // Write some text to the file
//     file.writeAsString('Hello, world!');

//     print('File created successfully.');
//   }
}
