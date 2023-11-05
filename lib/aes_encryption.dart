import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

class Encryption {
  final String passWord;
  final String fileName = "testFileVar";

  Encryption({this.passWord = "new Password"});

  void initEncryption() {
    final crypt = AesCrypt(passWord);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    crypt.encryptTextToFileSync("Top secret", "./testFolder/$fileName.txt.aes");
    // print(crypt.decryptTextFromFileSync("$fileName.txt.aes"));
  }
}
