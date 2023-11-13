import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_password_manager/file_manager.dart';

class Settings {
  static Map<String, dynamic> _settings = {};
  // ignore: prefer_final_fields
  static File _settingsFile =
      FileManager.findFile(".settings.json") ?? createSettingsFile();

  static Map<String, dynamic> get settings {
    String fileContent = FileManager.readFile(_settingsFile);
    _settings = json.decode(fileContent);
    return _settings;
  }

  static void addToSettings(String key, dynamic value) {
    String settingsData = FileManager.readFile(_settingsFile);
    Map<String, dynamic> settingJson = json.decode(settingsData);
    settingJson[key] = value;
    settingsData = json.encode(settingJson);
    FileManager.writeOnFile(_settingsFile, settingsData);
  }

  static File createSettingsFile() {
    String settingPath = ".settings.json";
    final settingFile = FileManager.createFile(settingPath);
    FileManager.writeOnFile(settingFile, writeSettings());
    return settingFile;
  }

  static String writeSettings() {
    Uint8List salt = Uint8List.fromList(
        utf8.encode("This is the salt and it's in plain text"));
    String saltStr = base64Encode(salt);

    Map<String, dynamic> settingsData = {
      'algorithmKeySize': 256,
      'pbkdf2Name': 'SHA-256/HMAC/PBKDF2',
      'pbkdf2Iterations': 32767,
      'salt': saltStr,
      'masterKey': "",
    };
    String jsonData = json.encode(settingsData);
    return jsonData;
  }
}
