import 'package:dart_password_manager/utils/cryptography.dart';
import 'package:dart_password_manager/utils/file_management.dart';
import 'package:test/test.dart';

void main() {
  String passwordName = "test";
  Map<String, dynamic> passwordDetails = {
    'passWordUserName': 'testUser',
    'passWord': '1234',
    'passWordUrl': '',
    'passWordDescription': 'test@test.com'
  };
  group('Encryption tests', () {
    //! note: before you run this test you need to check if the file already exits or it will fail, I will add later a function to delete a file.
    test(
        'When entering a correct details, we should find a file created as the destination and if tried to add another password with the same name an exception thrown',
        () {
      Cryptography.encrypt(
          masterPassWord: "mar",
          passwordName: passwordName,
          passwordDetails: passwordDetails);
      final file = FileManager.findFile("$passwordName.txt.aes");

      expect(file?.path.split("/").last, "test.txt.aes");
// If called again throw an exception
      expect(
          () => Cryptography.encrypt(
              masterPassWord: "mar",
              passwordName: passwordName,
              passwordDetails: passwordDetails),
          throwsA(isException));
    });
  });

  group("Decryption tests", () {
    test(
        'When entering the correct file name, we should get the password details as a string',
        () {
      final decryptedPassWordDetails = Cryptography.decrypt(
          masterPassWord: "mar", passWordName: passwordName);

      expect(decryptedPassWordDetails, passwordDetails);
    });
  });
}
