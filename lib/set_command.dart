import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/aes_algorithm.dart';
import 'package:dart_password_manager/settings.dart';

class SetCommand extends Command {
  @override
  String get name => "set";
  @override
  String get description => "add a new password to dpassman";

  @override
  FutureOr? run() {
    askForMasterKey();
    getPasswordName();
  }

  void askForMasterKey() {
    stdout.write("Please enter your master key: ");
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = AesAlgorithm.hashKey(masterKey);
      checkMasterKey(hashedMasterKey);
    } else {
      stdout.write("Please enter something!!");
      exit(2);
    }
  }

  void checkMasterKey(String hashedMasterKey) {
    String storedHMK = Settings.settings["masterKey"];
    if (storedHMK.isEmpty) {
      stdout.writeln("You did not initiated dpassman see (dpassman help)");
      exit(2);
    }
    if (storedHMK != hashedMasterKey) {
      stdout.write("Wrong master key");
      exit(2);
    }
  }

  void getPasswordName() {
    stdout.write("Please enter the name of the password: ");
    final passwordName = stdin.readLineSync();
    if (passwordName == null || passwordName.isEmpty) {
      stdout.writeln("You did not enter anything!!");
      exit(2);
    }
    print(passwordName);
  }
}
