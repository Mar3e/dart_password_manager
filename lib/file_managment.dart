import 'dart:io';

class FileManagement {
  String? homePath;
  late Directory appDirectory;

  void getHome() {
    homePath =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  }

  void createFolder() {
    // Create a folder in the home directory
    appDirectory = Directory('$homePath/passwordMan');

    // Create the folder if it doesn't already exist
    if (!appDirectory.existsSync()) {
      appDirectory.create();
      print('Folder created successfully.');
    } else {
      print('Folder already exists.${appDirectory.path}');
    }
  }

  void createFile() {
// Create a text file in the folder
    File file = File('${appDirectory.path}/my_file.txt');

    // Write some text to the file
    file.writeAsString('Hello, world!');

    print('File created successfully.');
  }
}
