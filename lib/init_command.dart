import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:args/command_runner.dart';
import 'package:dart_password_manager/core/settings.dart';
import 'package:dart_password_manager/file_manager.dart';
import 'package:pointycastle/api.dart';

class InitCommand extends Command {
  @override
  String get name => "init";

  @override
  String get description => "initializing the password manager";

  @override
  FutureOr? run() {
    initDPassMan();
    stdout.write("Please enter a master key to be used in encryption: ");
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      setMasterKey(masterKey);
    } else {
      throw Exception("you did not enter any thing!!");
    }
  }

  void initDPassMan() {
    final fileMan = FileManager();
    //* create the main folder
    Directory appDirectory = fileMan.createDir(".dpassman");

    if (!appDirectory.existsSync()) {
      appDirectory.create();
      stdout.writeln("Folder created successfully!");
    } else {
      stdout.writeln('You already initialized dpassman');
    }

    //* creating the settings file
    String settingPath = ".settings.json";
    final settingFile = fileMan.createFile(settingPath);
    fileMan.writeOnFile(settingFile, writeSettings());

    final settings = Settings(salt, algorithmKeySize: algorithmKeySize, pbkdf2Name: pbkdf2Name, pbkdf2Iterations: pbkdf2Iterations)
  }

  void setMasterKey(String masterKey) {
    // Convert the input string to bytes
    Uint8List inputBytes = Uint8List.fromList(utf8.encode(masterKey));

    // Create a SHA-256 hasher
    Digest sha256 = Digest('SHA-256');

    // Hash the input bytes using SHA-256
    Uint8List hashedBytes = sha256.process(inputBytes);

    // Convert the hashed bytes to a hexadecimal string
    String hashedString = base64.encode(hashedBytes);

    print('Hashed string: $hashedString');
  }

  String writeSettings() {
    Uint8List salt = Uint8List.fromList(
        utf8.encode("This is the salt and it's is in plain text"));
    String saltStr = base64Encode(salt);

    Map<String, dynamic> settingsData = {
      'algorithmKeySize': 256,
      'pbkdf2Name': 'SHA-256/HMAC/PBKDF2',
      'pbkdf2Iterations': 32767,
      'salt': saltStr
    };
    String jsonData = json.encode(settingsData);
    return jsonData;
  }
}
