import 'package:dart_password_manager/aes_encryption.dart';
import 'package:dart_password_manager/file_managment.dart';

void main(List<String> arguments) {
  final fileMan = FileManagement();
  fileMan.createFolder();

  final enc = Encryption();
  enc.initEncryption();
}
