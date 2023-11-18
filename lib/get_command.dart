import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/settings.dart';

class GetCommand extends Command {
  GetCommand() {
    argParser.addOption(
      "name",
      abbr: "n",
      help: "Specify the name of the password",
      defaultsTo: "",
    );
  }

  @override
  String get name => "get";
  @override
  String get description => "Retrieve a password form dpassman";

  @override
  FutureOr? run() {
    print(argResults?.name);
    searchForTheFile(argResults?["name"]);
    String masterKey = askForMasterKey();
    returnThePassword(masterKey);
  }

  void searchForTheFile(String? passWordName) {
    if (passWordName == null || passWordName.isEmpty) {
      stdout.writeln("You didn't specified a password. see dpassman help get");
      exit(2);
    } else {
      stdout.writeln("WTF $passWordName");
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

  void returnThePassword(String masterKey) {}
}
