import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/cli_clip_board.dart';
import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/file_management.dart';
import 'package:dart_password_manager/utils/settings.dart';

class GetCommand extends Command {
  GetCommand();
  @override
  String get name => "get";
  @override
  String get description => "Retrieve a password form dpassman";

  @override
  FutureOr? run() {
    String passWordName = searchForTheFile();
    String masterKey = askForMasterKey();
    returnThePassword(masterKey, passWordName);
  }

  String searchForTheFile() {
    stdout.write("What password are you looking for? ");
    final passWordName = stdin.readLineSync();
    if (passWordName == null || passWordName.isEmpty) {
      stdout.writeln("You didn't specified a password.");
      exit(2);
    } else {
      final result = FileManager.findFile("$passWordName.txt.aes");
      if (result == null) {
        stdout.write(
            "Couldn't find the password check the spelling or create \"$passWordName\" first");
        exit(2);
      } else {
        return passWordName;
      }
    }
  }

  String askForMasterKey() {
    stdout.write("Please enter your master key: ");
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = Cryptography.hashString(masterKey);
      checkMasterKey(hashedMasterKey);
      return masterKey;
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

  void returnThePassword(String masterKey, String passWordName) {
    final passwordDetails = Cryptography.decrypt(
        masterPassWord: masterKey, passWordName: passWordName);
    stdout.writeln("You password has been copy to the clipboard");
    Clipboard().write(passwordDetails["passWord"]);
  }
}
