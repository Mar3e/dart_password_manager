import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/file_management.dart';
import 'package:dart_password_manager/utils/settings.dart';

class RemoveCommand extends Command {
  @override
  String get name => "remove";
  @override
  String get description => "Delete a password form dpassman";
  @override
  FutureOr? run() {
    String passWordName = searchForTheFile();
    askForMasterKey();
    removePassWord(passWordName);
  }

  String searchForTheFile() {
    stdout.write("What password are you looking for? ");
    final passWordName = stdin.readLineSync();
    if (passWordName == null || passWordName.isEmpty) {
      stdout.writeln("You didn't specified a password.");
      exit(2);
    } else {
      final result = FileManager.findFile("$passWordName.json.aes");
      if (result == null) {
        stdout.write(
            "Couldn't find the password check the spelling or create \"$passWordName\" first");
        exit(2);
      } else {
        return passWordName;
      }
    }
  }

  void askForMasterKey() {
    stdout.write("Please enter your master key: ");
    stdin.echoMode = false;
    String? masterKey = stdin.readLineSync();
    stdin.echoMode = true;
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = Cryptography.hashString(masterKey);
      checkMasterKey(hashedMasterKey);
    } else {
      stdout.write("\nPlease enter something!!");
      exit(2);
    }
  }

  void checkMasterKey(String hashedMasterKey) {
    String storedHMK = Settings.settings["masterKey"];
    if (storedHMK.isEmpty) {
      stdout.writeln("\nYou did not initiated dpassman see (dpassman help)");
      exit(2);
    }
    if (storedHMK != hashedMasterKey) {
      stdout.write("\nWrong master key");
      exit(2);
    }
  }

  void removePassWord(String passWordName) {
    FileManager.deleteFile("$passWordName.json.aes");
  }
}
