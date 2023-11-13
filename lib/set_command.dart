import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/aes_algorithm.dart';
import 'package:dart_password_manager/settings.dart';

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
    String? masterKey = stdin.readLineSync();
    if (masterKey != null && masterKey.isNotEmpty) {
      String hashedMasterKey = AesAlgorithm.hashKey(masterKey);
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

  String getPasswordName() {
    stdout.write("Please enter the name of the password: ");
    final passWordName = stdin.readLineSync();
    if (passWordName == null || passWordName.isEmpty) {
      stdout.writeln("You did not enter anything!!");
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
      stdout.writeln("You did not enter anything!!");
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
      final passWord = stdin.readLineSync();
      if (passWord == null || passWord.isEmpty) {
        stdout.writeln("You did not enter anything!!");
        exit(2);
      }
      stdout.write("Please re enter the password: ");
      final rePassWord = stdin.readLineSync();
      if (rePassWord == null || rePassWord.isEmpty) {
        stdout.writeln("You did not enter anything!!");
        exit(2);
      } else if (passWord != rePassWord) {
        stdout.writeln("The password did not match!!");
        exit(2);
      } else {
        passwordDetails["passWord"] = passWord;
      }
    }
  }

  void getExtraDetails() {
    stdout
        .write("Please enter the URL associated with the password(Optional): ");
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
    AesAlgorithm.encrypt(
        masterPassWord: masterKey,
        passwordFileName: passwordName,
        passwordFileDetails: passwordDetails);
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
