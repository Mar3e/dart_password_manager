import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:dart_password_manager/file_manager.dart';
import 'package:dart_password_manager/settings.dart';
import 'package:pointycastle/pointycastle.dart';

class AesAlgorithm {
  static void encrypt({
    required String masterPassWord,
    required String passwordFileName,
    required Map<String, dynamic> passwordFileDetails,
  }) {
    Uint8List passphrase = Uint8List.fromList(utf8.encode(masterPassWord));
    Uint8List salt = Uint8List.fromList(utf8.encode(Settings.settings["salt"]));
    final key = _generateKey(salt, passphrase);
    String keyAsString = base64.encode(key);
    final crypt = AesCrypt(keyAsString);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    try {
      String fileName = passwordFileName;
      String passwordDetailsStr = json.encode(passwordFileDetails);
      crypt.encryptTextToFileSync(passwordDetailsStr,
          "${FileManager.homePath}/.dpassman/$fileName.txt.aes");
    } on AesCryptException {
      print("The file is already exists");
    }
  }

  static void decrypt({required String masterPassWord}) {
    Uint8List passphrase = Uint8List.fromList(utf8.encode(masterPassWord));

    Uint8List key = _generateKey(Settings.settings["salt"], passphrase);
    String keyAsString = base64.encode(key);
    final crypt = AesCrypt(keyAsString);

    stdout.write("What password do you want? ");
    String? fileName = stdin.readLineSync();

    final decryptedString =
        crypt.decryptTextFromFileSync("./testFolder/$fileName.txt.aes");

    print(decryptedString);
  }

  static Uint8List _generateKey(Uint8List salt, Uint8List passphrase) {
    var derivator = KeyDerivator(Settings.settings["pbkdf2Name"]);
    var params = Pbkdf2Parameters(salt, Settings.settings["pbkdf2Iterations"],
        Settings.settings["algorithmKeySize"] ~/ 8);
    derivator.init(params);
    return derivator.process(passphrase);
  }

  static String hashKey(String key) {
    // Convert the input string to bytes
    Uint8List keyBytes = Uint8List.fromList(utf8.encode(key));
    // Create a SHA-256 hasher
    Digest sha256 = Digest('SHA-256');

    // Hash the input bytes using SHA-256
    Uint8List hashedBytes = sha256.process(keyBytes);

    // Convert the hashed bytes to a hexadecimal string
    String hashedKey = base64.encode(hashedBytes);

    return hashedKey;
  }
}
