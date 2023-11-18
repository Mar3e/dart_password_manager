import 'dart:io';

class FileManager {
  static final homePath =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  static Directory createDir(String path) {
    return Directory("$homePath/$path");
  }

  static File createFile(String path) {
    return File("$homePath/$path");
  }

  static void writeOnFile(File file, String contents) {
    final editFile = file;
    editFile.writeAsStringSync(contents);
  }

  static File? findFile(String filePath) {
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
      return null;
    }
  }

  static String readFile(File file) {
    String fileContent = file.readAsStringSync();
    return fileContent;
  }
}
