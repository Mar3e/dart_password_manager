import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

class Encryption {
  final passWord;

  Encryption({this.passWord = "new Password"});

  void initCryption() {
    final crypt = AesCrypt(passWord);
    crypt.setOverwriteMode(AesCryptOwMode.warn);

    // crypt.encryptFileSync('testFile.txt');
    // crypt.decryptFileSync("testFile.txt.aes");
  }
}
