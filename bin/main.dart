import 'package:dart_password_manager/encryption.dart';

void main(List<String> arguments) {
  final enc = Encryption();

  enc.createFolder();

  enc.initEncryption();
}
