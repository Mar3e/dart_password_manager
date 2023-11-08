import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:args/command_runner.dart';
import 'package:dart_password_manager/core/statics_and_consts.dart';
import 'package:pointycastle/pointycastle.dart';

class AesAlgorithm extends Command {
  AesAlgorithm() {
    argParser.addFlag("encrypt",
        abbr: "e", negatable: false, help: "Encrypt the given password");
    argParser.addFlag("decrypt",
        abbr: "d", negatable: false, help: "Decrypt your password");
  }

// command properties
  @override
  final name = "safe";
  @override
  final description = "Allow you to encrypt or decrypt your passwords";
  @override
  FutureOr? run() {
    if (argResults?["encrypt"]) {
      stdout.write('Please enter your master password: '); // Prompt the user
      String? userMasterPassword = stdin.readLineSync();
      if (userMasterPassword != null && userMasterPassword.isNotEmpty) {
        _encrypt(
          masterPassWord: userMasterPassword,
        );
      } else {
        stdout.write('Error: you did not enter any thing!!');
      }
    } else if (argResults?["decrypt"]) {
      stdout.write('Please enter your master password: '); // Prompt the user
      String? userMasterPassword = stdin.readLineSync();
      if (userMasterPassword != null && userMasterPassword.isNotEmpty) {
        _decrypt(
          masterPassWord: userMasterPassword,
        );
      } else {
        stdout.write('Error: you did not enter any thing!!');
      }
    } else {
      print("Invalid operation");
    }
  }

  void _encrypt({required String masterPassWord}) {
    Uint8List passphrase = Uint8List.fromList(utf8.encode(masterPassWord));

    final key = _generateKey(salt, passphrase);
    // Convert the  Uint8List to a string
    String keyAsString = base64.encode(key);

    final crypt = AesCrypt(keyAsString);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    try {
      stdout.write("For what do you use this password? ");
      String fileName = stdin.readLineSync() ?? "No_name";
      stdout.write("Please enter your password: ");
      String? passwordPlainText = stdin.readLineSync();
      if (passwordPlainText != null && passwordPlainText.isNotEmpty) {
        crypt.encryptTextToFileSync(
            passwordPlainText, "./testFolder/$fileName.txt.aes");
      } else {
        stdout.write('Error: you did not enter any thing!!');
      }
    } on AesCryptException {
      print("The file is already exists");
    }
  }

  void _decrypt({required String masterPassWord}) {
    Uint8List passphrase = Uint8List.fromList(utf8.encode(masterPassWord));

    Uint8List key = _generateKey(salt, passphrase);
    String keyAsString = base64.encode(key);
    final crypt = AesCrypt(keyAsString);

    stdout.write("What password do you want? ");
    String? fileName = stdin.readLineSync();

    final decryptedString =
        crypt.decryptTextFromFileSync("./testFolder/$fileName.txt.aes");

    print(decryptedString);
  }

  Uint8List _generateKey(Uint8List salt, Uint8List passphrase) {
    var derivator = KeyDerivator(pbkdf2Name);
    var params =
        Pbkdf2Parameters(salt, pbkdf2Iterations, algorithmKeySize ~/ 8);
    derivator.init(params);
    return derivator.process(passphrase);
  }
}
