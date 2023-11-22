import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/file_management.dart';
import 'package:dart_password_manager/utils/settings.dart';

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
    try {
      Directory appDirectory = FileManager.createDir(".dpassman");

      if (!appDirectory.existsSync()) {
        final masterKey = askForMasterKey();
        await appDirectory.create();
        stdout.writeln("\nFolder created successfully!");
        Settings.createSettingsFile();
        setMasterKey(masterKey);
      } else {
        File? settingsFile = FileManager.findFile(".settings.json");

        if (settingsFile == null) {
          final masterKey = askForMasterKey();
          Settings.createSettingsFile();
          setMasterKey(masterKey);
        } else if (Settings.settings["masterKey"].isEmpty) {
          final masterKey = askForMasterKey();
          setMasterKey(masterKey);
        } else {
          stdout.writeln('You already initialized dpassman');
        }
      }
    } catch (e) {
      // Handle the exception here
      print('An exception occurred: $e');
    }
  }

  String askForMasterKey() {
    stdout.write("Please enter a master key to be used in encryption: ");
    stdin.echoMode = false;
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      return masterKey;
    } else {
      stdout.writeln("\nPlease enter something!!");
      exit(2);
    }
  }

  void setMasterKey(String masterKey) {
    String hashedMasterKey = Cryptography.hashString(masterKey);
    Settings.addToSettings("masterKey", hashedMasterKey);
  }
}
