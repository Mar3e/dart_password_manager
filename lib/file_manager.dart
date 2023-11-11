import 'dart:io';

class FileManager {
  final homePath =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  Directory createDir(String path) {
    return Directory("$homePath/$path");
  }

  File createFile(String path) {
    return File("$homePath/.dpassman/$path");
  }

  void writeOnFile(File file, String contents) {
    final editFile = file;
    editFile.writeAsStringSync(contents);
  }

  File findFile(String filePath) {
    Directory directory = Directory("$homePath/.dpassman");
    List<FileSystemEntity> files = directory.listSync(recursive: true);

    File? foundFile;
    for (var file in files) {
      if (file is File && file.path.endsWith(filePath)) {
        foundFile = file;
        break;
      }
    }

    if (foundFile != null) {
      // File found
      return foundFile;
    } else {
      throw Exception("No such file!!");
    }
  }

  String readFile(File file) {
    String fileContent = file.readAsStringSync();
    return fileContent;
  }
}
