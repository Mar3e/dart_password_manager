import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/aes_algorithm.dart';
import 'package:dart_password_manager/settings.dart';

class SetCommand extends Command {
  final aes = AesAlgorithm();
  final set = Settings();

  @override
  String get name => "set";
  @override
  String get description => "add a new password to dpassman";

  @override
  FutureOr? run() {
    askForMasterKey();
  }

  void askForMasterKey() {
    stdout.write("Please enter your master key: ");
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = aes.hashKey(masterKey);
      checkMasterKey(hashedMasterKey);
    } else {
      stdout.write("Please enter something!!");
      exit(2);
    }
  }

  void checkMasterKey(String hashedMasterKey) {
    String storedHMK = set.settings["masterKey"];
    if (storedHMK != hashedMasterKey) {
      stdout.write("Wrong master key");
      exit(2);
    }
  }
}
