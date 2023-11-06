import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

class Encryption {
  final String passWord;
  final String fileName = "testFileVar";
  String? homePath;
  late Directory appDirectory;

  Encryption({this.passWord = "new Password"}) {
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

  void initEncryption() {
    final crypt = AesCrypt(passWord);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    crypt.encryptTextToFileSync("Top secret", "./testFolder/$fileName.txt.aes");
    // print(crypt.decryptTextFromFileSync("$fileName.txt.aes"));
  }
}
