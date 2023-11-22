import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/settings.dart';

class SetCommand extends Command {
  SetCommand() {
    argParser.addFlag("generate",
        abbr: "g", negatable: false, help: "generate a password for the user.");
  }

  Map<String, dynamic> passwordDetails = {};
  @override
  String get name => "set";
  @override
  String get description => "add a new password to dpassman";

  @override
  FutureOr? run() {
    String masterKey = askForMasterKey();
    String passwordName = getPasswordName();
    getPasswordUserName();
    getThePassword();
    getExtraDetails();
    savePassWord(
      masterKey: masterKey,
      passwordName: passwordName,
      passwordDetails: passwordDetails,
    );
  }

  String askForMasterKey() {
    stdout.write("Please enter your master key: ");
    stdin.echoMode = false;
    String? masterKey = stdin.readLineSync();
    stdin.echoMode = true;
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = Cryptography.hashString(masterKey);
      checkMasterKey(hashedMasterKey);
      return masterKey;
    } else {
      stdout.writeln("\nPlease enter something!!");
      exit(2);
    }
  }

  void checkMasterKey(String hashedMasterKey) {
    String storedHMK = Settings.settings["masterKey"];
    if (storedHMK.isEmpty) {
      stdout.write("\nYou did not initiated dpassman see (dpassman help)");
      exit(2);
    }
    if (storedHMK != hashedMasterKey) {
      stdout.writeln("\nWrong master key");
      exit(2);
    }
  }

  String getPasswordName() {
    stdout.write("\nPlease enter the name of the password: ");
    final passWordName = stdin.readLineSync();
    if (passWordName == null || passWordName.isEmpty) {
      stdout.writeln("\nYou did not enter anything!!");
      exit(2);
    } else {
      return passWordName;
    }
  }

  void getPasswordUserName() {
    stdout.write(
        "Please enter the userName or Email associated with the password: ");
    final passWordUserName = stdin.readLineSync();
    if (passWordUserName == null || passWordUserName.isEmpty) {
      stdout.writeln("\nYou did not enter anything!!");
      exit(2);
    } else {
      passwordDetails["passWordUserName"] = passWordUserName;
    }
  }

  void getThePassword() {
    if (argResults?["generate"] ?? false) {
      String generatedPassword = generatePassWord();
      passwordDetails["passWord"] = generatedPassword;
      stdout.writeln(
          "Your generated password is: \x1B[33m$generatedPassword\x1b[0m");
    } else {
      stdout.write("Please enter the password: ");
      stdin.echoMode = false;
      final passWord = stdin.readLineSync()?.trim();

      if (passWord == null || passWord.isEmpty) {
        stdout.writeln("\nYou did not enter anything!!");
        exit(2);
      }
      stdout.write("\nPlease re enter the password: ");
      final rePassWord = stdin.readLineSync()?.trim();
      stdin.echoMode = true;
      if (rePassWord == null || rePassWord.isEmpty) {
        stdout.writeln("\nYou did not enter anything!!");
        exit(2);
      } else if (passWord != rePassWord) {
        stdout.writeln("\nThe password did not match!!");
        exit(2);
      } else {
        passwordDetails["passWord"] = passWord;
      }
    }
  }

  void getExtraDetails() {
    stdout.write(
        "\nPlease enter the URL associated with the password(Optional): ");
    final passWordUrl = stdin.readLineSync();
    passwordDetails["passWordUrl"] = passWordUrl ?? "";

    stdout.write("Please enter the discretion of password(Optional): ");
    final passWordDescription = stdin.readLineSync();
    passwordDetails["passWordDescription"] = passWordDescription ?? "";
  }

  void savePassWord({
    required String masterKey,
    required String passwordName,
    required Map<String, dynamic> passwordDetails,
  }) {
    try {
      Cryptography.encrypt(
          masterPassWord: masterKey,
          passwordName: passwordName,
          passwordDetails: passwordDetails);
    } catch (e) {
      stdout.writeln(e);
    }
  }

  String generatePassWord() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[{]}\\|;:\'",<.>/?';
    Random rnd = Random.secure();

    String generatedPassword = String.fromCharCodes(
      Iterable.generate(
        Settings.settings["generatedPasswordLength"],
        (_) => chars.codeUnitAt(
          rnd.nextInt(chars.length),
        ),
      ),
    );

    return generatedPassword;
  }
}
