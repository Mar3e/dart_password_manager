import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/aes_algorithm.dart';
import 'package:dart_password_manager/file_manager.dart';
import 'package:dart_password_manager/settings.dart';
import 'package:pointycastle/api.dart';

class InitCommand extends Command {
  @override
  String get name => "init";
  final fileMan = FileManager();

  @override
  String get description => "initializing the password manager";

  @override
  FutureOr? run() {
    initDPassMan();
  }

  void initDPassMan() async {
    Directory appDirectory = fileMan.createDir(".dpassman");

    if (!appDirectory.existsSync()) {
      final masterKey = askForMasterKey();
      await appDirectory.create();
      stdout.writeln("Folder created successfully!");
      createSettingsFile();
      setMasterKey(masterKey);
    } else {
      stdout.writeln('You already initialized dpassman');
    }
  }

  void createSettingsFile() {
    String settingPath = ".settings.json";
    final settingFile = fileMan.createFile(settingPath);
    fileMan.writeOnFile(settingFile, writeSettings());
  }

  String askForMasterKey() {
    stdout.write("Please enter a master key to be used in encryption: ");
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      return masterKey;
    } else {
      stdout.write("Please enter something!!");
      exit(2);
    }
  }

  void setMasterKey(String masterKey) {
    final aes = AesAlgorithm();
    String hashedMasterKey = aes.hashKey(masterKey);
    final set = Settings();
    set.addToSettings("masterKey", hashedMasterKey);
  }

  String writeSettings() {
    Uint8List salt = Uint8List.fromList(
        utf8.encode("This is the salt and it's is in plain text"));
    String saltStr = base64Encode(salt);

    Map<String, dynamic> settingsData = {
      'algorithmKeySize': 256,
      'pbkdf2Name': 'SHA-256/HMAC/PBKDF2',
      'pbkdf2Iterations': 32767,
      'salt': saltStr,
      'masterKey': "",
    };
    String jsonData = json.encode(settingsData);
    return jsonData;
  }
}
