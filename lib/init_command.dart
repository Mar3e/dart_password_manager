import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/cryptography.dart';
import 'package:dart_password_manager/file_manager.dart';
import 'package:dart_password_manager/settings.dart';

class InitCommand extends Command {
  @override
  String get name => "init";

  @override
  String get description => "initializing the password manager";

  @override
  FutureOr? run() {
    initDPassMan();
  }

  void initDPassMan() async {
    Directory appDirectory = FileManager.createDir(".dpassman");
    File? settingsFile = FileManager.findFile(".settings.json");
    String storedMasterKey = Settings.settings["masterKey"];

    if (!appDirectory.existsSync()) {
      final masterKey = askForMasterKey();
      await appDirectory.create();
      stdout.writeln("Folder created successfully!");
      Settings.createSettingsFile();
      setMasterKey(masterKey);
    } else if (settingsFile == null) {
      final masterKey = askForMasterKey();
      Settings.createSettingsFile();
      setMasterKey(masterKey);
    } else if (storedMasterKey.isEmpty) {
      final masterKey = askForMasterKey();
      setMasterKey(masterKey);
    } else {
      stdout.writeln('You already initialized dpassman');
    }
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
    String hashedMasterKey = Cryptography.hashString(masterKey);
    Settings.addToSettings("masterKey", hashedMasterKey);
  }
}
