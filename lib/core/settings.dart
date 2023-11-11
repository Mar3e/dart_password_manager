import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_password_manager/file_manager.dart';

class Settings {
  final int algorithmKeySize;
  final String pbkdf2Name;
  final int pbkdf2Iterations;
  final Uint8List salt;

  Settings() {
    final fileMan = FileManager();
    File settingsFile = fileMan.findFile(".settings.json");
    String fileContent = fileMan.readFile(settingsFile);
    Map<String, dynamic> restoredSettingsData = json.decode(fileContent);
    print(restoredSettingsData);
  }
}
