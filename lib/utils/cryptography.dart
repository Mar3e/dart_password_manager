import 'dart:convert';
import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:dart_password_manager/utils/file_management.dart';
import 'package:dart_password_manager/utils/settings.dart';
import 'package:pointycastle/pointycastle.dart';

class Cryptography {
  static void encrypt({
    required String masterPassWord,
    required String passwordName,
    required Map<String, dynamic> passwordDetails,
  }) {
    Uint8List key = _generateKey(Settings.settings["salt"], masterPassWord);
    String keyAsString = base64.encode(key);
    final crypt = AesCrypt(keyAsString);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    try {
      String passwordDetailsStr = json.encode(passwordDetails);
      crypt.encryptTextToFileSync(passwordDetailsStr,
          "${FileManager.homePath}/.dpassman/$passwordName.json.aes");
    } on AesCryptException {
      throw Exception("The password already exists");
    }
  }

  static Map<String, dynamic> decrypt({
    required String masterPassWord,
    required String passWordName,
  }) {
    Uint8List key = _generateKey(Settings.settings["salt"], masterPassWord);
    String keyAsString = base64.encode(key);
    final crypt = AesCrypt(keyAsString);

    final decryptedString = crypt.decryptTextFromFileSync(
        "${FileManager.homePath}/.dpassman/$passWordName.json.aes");

    Map<String, dynamic> decryptedMap = json.decode(decryptedString);

    return decryptedMap;
  }

  static Uint8List _generateKey(String salt, String masterPassWord) {
    Uint8List passphrase = Uint8List.fromList(utf8.encode(masterPassWord));
    Uint8List salt = Uint8List.fromList(utf8.encode(Settings.settings["salt"]));

    var derivator = KeyDerivator(Settings.settings["pbkdf2Name"]);
    var params = Pbkdf2Parameters(salt, Settings.settings["pbkdf2Iterations"],
        Settings.settings["algorithmKeySize"] ~/ 8);
    derivator.init(params);

    return derivator.process(passphrase);
  }

  static String hashString(String key) {
    Uint8List keyBytes = Uint8List.fromList(utf8.encode(key));

    Digest sha256 = Digest('SHA-256');

    Uint8List hashedBytes = sha256.process(keyBytes);

    String hashedKey = base64.encode(hashedBytes);

    return hashedKey;
  }
}
