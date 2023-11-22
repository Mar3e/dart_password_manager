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

  static void deleteFile(String filePath) {
    File file = File("$homePath/.dpassman/$filePath");

    if (file.existsSync()) {
      file.deleteSync();
      stdout.writeln('\nPassword deleted successfully.');
    } else {
      stdout.writeln('Password not found.');
    }
  }

  static void showAllFiles() {
    Directory directory = Directory("$homePath/.dpassman");
    List<FileSystemEntity> files = directory.listSync(recursive: true);
    if (files.length > 1) {
      for (final file in files) {
        final fileName = file.path.split('/').last;
        final fileNameWithoutExtension = fileName.split('.').first;
        if (!fileName.startsWith('.')) {
          stdout.writeln(fileNameWithoutExtension);
        }
      }
    } else {
      stdout.write("You did not set any passwords yet!!");
    }
  }
}
