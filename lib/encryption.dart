import 'dart:async';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:args/command_runner.dart';

class Encryption extends Command {
  final String passWord;
  final String fileName = "testFileVar";
  String? homePath;
  late Directory appDirectory;

  Encryption({this.passWord = "new Password"}) {
    homePath =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  }

  @override
  final name = "encrypt";

  @override
  final description =
      "encrypt a give password and save it in '~/projects/dart_password_manager/testFolder'.";

  @override
  FutureOr? run() {
    createFolder();
    initEncryption("qwerty");
  }

  void createFolder() {
    // Create a folder in the home directory
    appDirectory =
        Directory('$homePath/projects/dart_password_manager/testFolder');

    // Create the folder if it doesn't already exist
    if (!appDirectory.existsSync()) {
      appDirectory.create();
      stdout.write("Folder created successfully!");
    } else {
      stdout.write('Folder already exists.${appDirectory.path}');
    }
  }

  void initEncryption(String usePassWord) {
    final crypt = AesCrypt(passWord);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    crypt.encryptTextToFileSync(
        "usePassWord", "./testFolder/$fileName.txt.aes");
    // print(crypt.decryptTextFromFileSync("$fileName.txt.aes"));
  }
}
